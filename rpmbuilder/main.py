import sys
from typing import List, Optional
from distutils.util import strtobool
from actions_toolkit import core
from rpmbuilder.building import (
    run_spectool,
    build_all,
    build_binary,
    populate_build_tree,
)
from rpmbuilder.packages import install_packages, install_build_dependencies


def builder(
    spec: str,
    spectool: bool = True,
    packages: Optional[List[str]] = None,
    build_type: str = "bb",
    source_dir: str = "SOURCES",
    output_dir: str = ".",
):
    if packages:
        install_packages(packages)
    populate_build_tree(spec, source_dir)
    if spectool:
        run_spectool(spec)
    install_build_dependencies(spec)
    if build_type == "ba":
        files = build_all(spec, output_dir)
    else:
        files = build_binary(spec, output_dir)
    core.set_output("rpm_files", ",".join(files))
    core.info("rpmbuilder completed")


def run():
    spec = core.get_input("spec")
    spectool = strtobool(core.get_input("spectool", False))
    build_type = core.get_input("build_type", False)
    source_dir = core.get_input("source_dir", False)
    output_dir = core.get_input("output_dir", False)
    sys.exit(
        builder(
            spec,
            spectool=spectool,
            build_type=build_type,
            source_dir=source_dir,
            output_dir=output_dir,
        )
    )


if __name__ == "__main__":
    run()
