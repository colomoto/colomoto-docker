# -*- coding: utf-8

from setuptools import setup

setup(name="colomoto-docker",
    version = "5.1",
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
