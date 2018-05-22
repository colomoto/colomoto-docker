#!/usr/bin/env python

from argparse import ArgumentParser
import os
from contextlib import closing
import platform
import socket
import subprocess
import sys
import webbrowser

def main():
    parser = ArgumentParser()
    parser.add_argument("--bind", default=None, type=str,
        help="Bind specified path to the docker working directory")
    parser.add_argument("-w", "--workdir", default="/notebook", type=str,
        help="Workdir within the docker image")
    parser.add_argument("--shell", default=False, action="store_true",
        help="Start interactive shell instead of notebook service")
    parser.add_argument("-V", "--version", type=str, default="latest",
        help="Version of docker image (latest to fetch the latest tag)")
    parser.add_argument("--port", default=0, type=int,
        help="Local port")
    parser.add_argument("--image", default="colomoto/colomoto-docker",
        help="Docker image")
    parser.add_argument("--no-browser", default=False, action="store_true",
        help="Do not start the browser")
    parser.add_argument("--unsafe-ssl", default=False, action="store_true",
        help="Do not check for SSL certificates")

    group = parser.add_argument_group("docker run options")
    group.add_argument("-e", "--env", metavar="list",
        help="Set environment variables")
    group.add_argument("--name",
        help="Name of the container")
    group.add_argument("-v", "--volume", metavar="list",
        help="Bind mount a volume")
    docker_run_opts = ["env", "name", "volume"]

    parser.add_argument("command", nargs="*", help="Command to run instead of colomoto-nb")
    args = parser.parse_args()

    if args.version == "latest":
        import json
        try:
            from urllib.request import urlopen
        except ImportError:
            from urllib2 import urlopen

        if args.unsafe_ssl or platform.system() != "Linux":
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
        tags = [t["name"] for t in r if len(t["name"])==10 and "-" in t["name"]]
        if not tags:
            print("# ... none found! use 'latest'")
            image_tag = "latest"
        else:
            image_tag = max(tags)
            print("# ... using {}".format(image_tag))
    else:
        image_tag = args.version

    image = "%s:%s" % (args.image, image_tag)

    if image_tag == "next" or not subprocess.check_output(["docker", "images", "-q", image]):
        subprocess.check_call(["docker", "pull", image])


    argv = ["docker", "run", "-it", "--rm"]
    if args.bind:
        argv += ["--volume", "%s:%s" % (os.path.abspath(args.bind), args.workdir)]
    argv += ["-w", args.workdir]

    if not args.shell:
        container_ip = "127.0.0.1"
        docker_machine = os.getenv("DOCKER_MACHINE_NAME")
        if docker_machine:
            container_ip = subprocess.check_output(["docker-machine", "ip", docker_machine])
            container_ip = container_ip.decode().strip().split("%")[0]
            port = args.port if args.port else 8888
        elif args.port == 0:
            # find next available
            for port in range(8888, 65535):
                with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
                    try:
                        s.bind((container_ip, port))
                        break
                    except:
                        pass
        else:
            port = args.port

        argv += ["-p", "%s:8888" % port]

    for opt in docker_run_opts:
        if getattr(args, opt) is not None:
            argv += ["--%s" % opt, getattr(args, opt)]
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
                    webbrowser.open("http://{}:{}".format(container_ip, port))
            elif p.poll() is not None:
                break

    else:
        os.execvp(argv[0], argv)

if __name__ == "__main__":
    main()
