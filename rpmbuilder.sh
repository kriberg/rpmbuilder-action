#!/bin/bash
set -e
PWD=$(pwd)
BUILDROOT=$(mktemp -p $PWD -d rpmbuilder.XXX )
SPEC_FILE="$BUILDROOT/SPECS/$(basename $INPUT_SPEC)"

install_packages () {
    yum install -y $INPUT_PACKAGES
}

populate_build_tree () {
    echo "%_topdir  $BUILDROOT" > $HOME/.rpmmacros
    rpmdev-setuptree
    cp $INPUT_SPEC $SPEC_FILE
    if [[ -v INPUT_SOURCE_DIR && -d $INPUT_SOURCE_DIR ]]; then
        cp -R $INPUT_SOURCE_DIR/* $BUILDROOT/SOURCES/
    fi
}

run_spectool () {
    spectool -g -R $SPEC_FILE
}

install_build_dependencies () {
    yum-builddep -y $SPEC_FILE
}

build_spec () {
    rpmbuild -$INPUT_BUILD_TYPE $SPEC_FILE
}

copy_rpm_files () {
    mkdir -p $INPUT_OUTPUT_DIR
    find $BUILDROOT/RPMS -type f -name '*.rpm' -exec cp {} $INPUT_OUTPUT_DIR \;
    find $BUILDROOT/SRPMS -type f -name '*.rpm' -exec cp {} $INPUT_OUTPUT_DIR \;
    echo "::set-output name=rpm_files::$(find $INPUT_OUTPUT_DIR -type f -name '*.rpm' |xargs)"
}


if [[ ! -v INPUT_SPEC ]]; then
    echo "::error Specfile not defined"
    exit 1
fi
if [[ ! -f "$INPUT_SPEC" ]]; then
    echo "::error Specfile does not exist"
    exit 1
fi

echo "::group::Installing packages"
if [[ -v INPUT_PACKAGES ]]; then
    install_packages
fi
echo "::endgroup::"

echo "::group::Populating build tree"
populate_build_tree
echo "::endgroup::"

echo "::group::Running spectool"
if [[ -v INPUT_SPECTOOL ]]; then
    run_spectool
fi
echo "::endgroup::"

echo "::group::Installing build dependencies"
install_build_dependencies
echo "::endgroup::"

echo "::group::Running rpmbuild"
build_spec
echo "::endgroup::"

echo "::group::Copying RPM files"
copy_rpm_files
echo "::endgroup::"

rm -rf $BUILDROOT
