#!/usr/bin/env python

from argparse import ArgumentParser
import os

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

os.execvp(argv[0], argv)
