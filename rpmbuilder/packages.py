from typing import List
from rpmbuilder.cmd import run


def install_packages(packages: List[str]):
    run(["yum", "install", "-y", " ".join(packages)])


def install_build_dependencies(spec: str):
    run(["yum-builddep", "-y", "--spec", spec])
