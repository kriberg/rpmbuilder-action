import subprocess
import logging
from typing import List

log = logging.getLogger(__name__)


def install_packages(packages: List[str]):
    proc = subprocess.run(["yum", "install", "-y", " ".join(packages)])
    log.info(proc.stdout)
    log.error(proc.stderr)
    return proc.returncode


def install_build_dependencies(spec: str):
    proc = subprocess.run(["yum-builddep", "-y", "--spec", spec])
    log.info(proc.stdout)
    log.error(proc.stderr)
    return proc.returncode