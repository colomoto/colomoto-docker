#!/usr/bin/env python

from argparse import ArgumentParser
import os
from multiprocessing import Process
import sys
import webbrowser

parser = ArgumentParser()
parser.add_argument("--bind", default=None, type=str,
    help="Bind specified path to the docker working directory")
parser.add_argument("-w", "--workdir", default="/notebook", type=str,
    help="Workdir within the docker image")
parser.add_argument("--shell", default=False, action="store_true",
    help="Start interactive shell instead of notebook service")
parser.add_argument("-V", "--version", type=str, default="latest",
    help="Version of docker image (latest to fetch the latest tag)")
parser.add_argument("--port", default=8888, type=int,
    help="Local port")
parser.add_argument("--image", default="colomoto/colomoto-docker",
    help="Docker image")
parser.add_argument("--no-browser", default=False, action="store_true",
    help="Do not start the browser")
parser.add_argument("docker_options", nargs="*")
args = parser.parse_args()

if args.version == "latest":
    import json
    try:
        from urllib.request import urlopen
    except ImportError:
        from urllib2 import urlopen

    print("# querying for latest tag of {}...".format(args.image))
    url_api = "https://registry.hub.docker.com/v1/repositories/{}/tags".format(args.image)
    tags = []
    q = urlopen(url_api)
    r = json.load(q)
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

argv = ["docker", "run", "-it", "--rm", "-p", "%s:8888" % args.port]
if args.bind:
    argv += ["--volume", "%s:%s" % (os.path.abspath(args.bind), args.workdir)]
argv += ["-w", args.workdir]
argv += args.docker_options
argv += ["%s:%s" % (args.image, image_tag)]
if args.shell:
    argv += ["bash"]

print("# %s" % " ".join(argv))

if not args.shell and not args.no_browser:
    rpipe, wpipe = os.pipe()

    def wait_and_run():
        os.close(wpipe)
        launched = False
        while True:
            line = os.read(rpipe, 1024)
            if not line:
                break
            os.write(sys.stdout.fileno(), line)
            line = line.decode()
            if not launched and "The Jupyter Notebook is running at:" in line:
                launched = True
                webbrowser.open("http://127.0.0.1:%s" % args.port)

    p = Process(target=wait_and_run)
    p.start()
    os.close(rpipe)
    os.dup2(wpipe, sys.stdout.fileno())

os.execvp(argv[0], argv)
