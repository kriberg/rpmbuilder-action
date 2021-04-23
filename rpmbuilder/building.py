import glob
import os
import subprocess
import shutil
import sys
from typing import List, Tuple

from actions_toolkit import core



def run_spectool(spec: str):
    proc = subprocess.run(["spectool", "-g", "-R", spec])
    core.info(str(proc.stdout))
    if not proc.returncode == 0:
        core.set_failed(str(proc.stderr))


def build_binary(spec: str, output_dir: str) -> List[str]:
    proc = subprocess.run(["rpmbuild", "-bb", spec])
    core.info(str(proc.stdout))
    if not proc.returncode == 0:
        core.set_failed(str(proc.stderr))
    try:
        rpms = glob.glob("/root/rpmbuild/RPMS/*.rpm")
        destination = os.path.join("/github/workspace", output_dir)
        output_files = []
        if not os.path.exists(destination):
            os.makedirs(destination)
        for rpm in rpms:
            shutil.copy(rpm, destination)
            output_files.append(os.path.join(output_dir, rpm))
    except Exception as exc:
        core.set_failed(f"Failed copying packages: {exc}")
        sys.exit(1)
    return output_files


def build_all(spec: str, output_dir: str) -> List[str]:
    proc = subprocess.run(["rpmbuild", "-ba", spec])
    core.info(str(proc.stdout))
    if not proc.returncode == 0:
        core.set_failed(str(proc.stderr))
    try:
        rpms = glob.glob("/root/rpmbuild/RPMS/*.rpm")
        srpms = glob.glob("/root/rpmbuild/SRPMS/*.rpm")
        destination = os.path.join("/github/workspace", output_dir)
        output_files = []
        if not os.path.exists(destination):
            os.makedirs(destination)
        for rpm in rpms:
            shutil.copy(rpm, destination)
            output_files.append(os.path.join(output_dir, rpm))
        for srpm in srpms:
            shutil.copy(srpm, destination)
            output_files.append(os.path.join(output_dir, srpm))
    except Exception as exc:
        core.set_failed(f"Failed copying packages: {exc}")
        sys.exit(1)
    return output_files


def populate_build_tree(spec: str, source_dir=None):
    try:
        shutil.copy(spec, "/root/rpmbuild/SPECS/")
        abs_source_dir = os.path.join("/github/workspace", source_dir)
        if os.path.exists(abs_source_dir):
            core.info(f"Copying source files from {source_dir}")
            shutil.copy(os.path.join(abs_source_dir, "*"), "/root/rpmbuild/SOURCES/")
    except Exception as exc:
        core.set_failed(f"Failed populating package tree: {exc}")