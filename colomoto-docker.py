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
    help="Version of docker image")
parser.add_argument("--port", default=8888, type=int,
    help="Local port")
parser.add_argument("--image", default="colomoto/colomoto-docker",
    help="Docker image")
parser.add_argument("docker_options", nargs="*")
args = parser.parse_args()


argv = ["docker", "run", "-it", "--rm", "-p", "%s:8888" % args.port]
if args.bind:
    argv += ["--volume", "%s:%s" % (os.path.abspath(args.bind), args.workdir)]
argv += ["-w", args.workdir]
argv += args.docker_options
argv += ["%s:%s" % (args.image, args.version)]
if args.shell:
    argv += ["bash"]

print("# %s" % " ".join(argv))

if not args.shell:
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
