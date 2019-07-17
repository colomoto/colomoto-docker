#!/usr/bin/env python

from __future__ import print_function

from argparse import ArgumentParser
import os
from contextlib import closing
import platform
import re
import socket
import subprocess
import sys
import webbrowser

on_linux = platform.system() == "Linux"

pat_tag = re.compile(r"\d{4}-\d{2}-\d{2}")

def error(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)

def check_cmd(argv):
    DEVNULL = subprocess.DEVNULL if hasattr(subprocess, "DEVNULL") \
                else open(os.devnull, 'w')
    try:
        subprocess.call(argv, stdout=DEVNULL, stderr=DEVNULL, close_fds=True)
        return True
    except:
        return False

def check_sudo():
    return check_cmd(["sudo", "true"])

def docker_call():
    direct_docker = ["docker"]
    sudo_docker = ["sudo", "docker"]
    if on_linux:
        import grp
        try:
            docker_grp = grp.getgrnam("docker")
            if docker_grp.gr_gid in os.getgroups():
                return direct_docker
        except KeyError:
            raise
        if not check_sudo():
            error("""Error: 'sudo' is not installed and you are not in the 'docker' group.
Either install sudo, or add your user to the docker group by doing
   su -c "usermod -aG docker $USER" """)
        return sudo_docker
    return direct_docker

def check_docker():
    if not check_cmd(["docker", "version"]):
        if not on_linux:
            error("""Error: Docker not found.
If you are using Docker Toolbox, make sure you are running 'colomoto-docker'
within the 'Docker quickstart Terminal'.""")
        else:
            error("Error: Docker not found.")
    docker_argv = docker_call()
    if subprocess.call(docker_argv + ["version"]):
        error("Error: cannot connect to Docker. Make sure it is running.")
    return docker_argv


def main():
    parser = ArgumentParser()
    parser.add_argument("--bind", default=None, type=str,
        help="Bind specified path to the docker working directory")
    parser.add_argument("--no-selinux", default=False, action="store_true",
        help="Disable SElinux for this container")
    parser.add_argument("-w", "--workdir", default="/notebook", type=str,
        help="Workdir within the docker image")
    parser.add_argument("--shell", default=False, action="store_true",
        help="Start interactive shell instead of notebook service")
    parser.add_argument("-V", "--version", type=str, default="same",
        help="""Version of docker image ('latest' to fetch the latest tag;
        'same' for most recently fetched image)""")
    parser.add_argument("--port", default=0, type=int,
        help="Local port")
    parser.add_argument("--image", default="colomoto/colomoto-docker",
        help="Docker image")
    parser.add_argument("--no-browser", default=False, action="store_true",
        help="Do not start the browser")
    parser.add_argument("--unsafe-ssl", default=False, action="store_true",
        help="Do not check for SSL certificates")
    parser.add_argument("--no-update", default=False, action="store_true",
        help="Do not check for image update")
    parser.add_argument("--cleanup", default=False, action="store_true",
        help="Cleanup old images")

    group = parser.add_argument_group("docker run options")
    group.add_argument("-e", "--env", action="append",
        help="Set environment variables")
    group.add_argument("--name", help="Name of the container")
    group.add_argument("-v", "--volume", action="append",
        help="Bind mount a volume")
    docker_run_opts = ["env", "name", "volume"]

    parser.add_argument("command", nargs="*", help="Command to run instead of colomoto-nb")
    args = parser.parse_args()

    image_tag = args.version

    if args.version == "same":
        output = subprocess.check_output(["docker", "images", "-f",
                                    "reference=colomoto/colomoto-docker",
                                    "--format", "{{.Tag}}"])
        output = output.decode()
        if not output:
            args.version = "latest"
        else:
            image_tag = output.split("\n")[0]

    docker_argv = check_docker()

    if args.version == "latest":
        import json
        try:
            from urllib.request import urlopen
        except ImportError:
            from urllib2 import urlopen

        if args.unsafe_ssl or not on_linux:
            # disable SSL verification...
            import ssl
            ssl._create_default_https_context = ssl._create_unverified_context

        print("# querying for latest tag of {}...".format(args.image))
        url_api = "https://registry.hub.docker.com/v1/repositories/{}/tags".format(args.image)
        tags = []
        q = urlopen(url_api)
        data = q.read().decode("utf-8")
        r = json.loads(data)
        q.close()
        tags = [t["name"] for t in r if pat_tag.match(t["name"])]
        if not tags:
            print("# ... none found! use 'latest'")
            image_tag = "latest"
        else:
            image_tag = max(tags)

    image = "%s:%s" % (args.image, image_tag)
    print("# using {}".format(image))

    if not args.no_update \
        and (image_tag.startswith("next") \
            or not subprocess.check_output(docker_argv + ["images", "-q", image])):
        subprocess.check_call(docker_argv + ["pull", image])

    if args.cleanup:
        output = subprocess.check_output(docker_argv + ["images", "-f",
                                    "reference=colomoto/colomoto-docker",
                                    "--format", "{{.Tag}} {{.ID}}"])
        todel = []
        for line in output.decode().split("\n"):
            if not line:
                continue
            tag, iid = line.split()
            if tag == image_tag:
                continue
            if tag == "<none>":
                todel.append(iid)
            else:
                todel.append("{}:{}".format(args.image, tag))
        if todel:
            argv = docker_argv + ["rmi"] + todel
            print("# {}".format(" ".join(argv)))
            subprocess.call(argv)

    argv = docker_argv + ["run", "-it", "--rm"]
    if args.no_selinux:
        argv += ["--security-opt", "label:disable"]
    if args.bind:
        argv += ["--volume", "%s:%s" % (os.path.abspath(args.bind), args.workdir)]
    argv += ["-w", args.workdir]

    if not args.shell and not args.command:
        container_ip = "127.0.0.1"
        docker_machine = os.getenv("DOCKER_MACHINE_NAME")
        if docker_machine:
            container_ip = subprocess.check_output(["docker-machine", "ip", docker_machine])
            container_ip = container_ip.decode().strip().split("%")[0]
        if args.port == 0:
            # find next available
            for port in range(8888, 65535):
                with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
                    dest_addr = (container_ip, port)
                    if s.connect_ex(dest_addr):
                        break
        else:
            port = args.port

        argv += ["-p", "%s:8888" % port]


    # forward proxy configuration
    for env in ["HTTP_PROXY", "HTTPS_PROXY", "FTP_PROXY", "NO_PROXY"]:
        if env in os.environ:
            argv += ["-e", env]

    for opt in docker_run_opts:
        if getattr(args, opt) is not None:
            val = getattr(args, opt)
            if isinstance(val, list):
                for v in val:
                    argv += ["--%s"%opt, v]
            else:
                argv += ["--%s" % opt, val]

    argv += [image]
    if args.shell:
        argv += ["bash"]
    elif args.command:
        argv += args.command

    print("# %s" % " ".join(argv))

    if not args.shell and not args.command and not args.no_browser:

        p = subprocess.Popen(argv, stdout=subprocess.PIPE)

        launched = False
        while True:
            line = os.read(p.stdout.fileno(), 1024)
            if line:
                os.write(sys.stdout.fileno(), line)
                line = line.decode()
                if not launched and "The Jupyter Notebook is running at:" in line:
                    launched = True
                    try:
                        webbrowser.open("http://{}:{}".format(container_ip, port))
                    except:
                        print("""
Please open your web-browser to the following address:

    http://{}:{}

""".format(container_ip, port))
            elif p.poll() is not None:
                break

    else:
        os.execvp(argv[0], argv)

if __name__ == "__main__":
    main()
