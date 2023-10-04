# -*- coding: utf-8

from setuptools import setup

with open("colomoto_docker.py") as fp:
    for line in fp:
        if line.startswith("__version__"):
            version = line.split("=")[-1].strip().strip('"')

setup(name="colomoto-docker",
    version = version,
    author = "Loïc Paulevé",
    author_email = "loic.pauleve@ens-cachan.org",
    url = "https://github.com/colomoto/colomoto-docker",
    description = "Helper script to run docker image colomoto/colomoto-docker",
    py_modules = ["colomoto_docker"],
    entry_points = {
        "console_scripts": [
            "colomoto-docker = colomoto_docker:main"
        ]
    }
)
