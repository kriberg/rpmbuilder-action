from typing import List
from exec import exec


def install_packages(packages: List[str]):
    exec(["yum", "install", "-y", " ".join(packages)])


def install_build_dependencies(spec: str):
    exec(["yum-builddep", "-y", "--spec", spec])
