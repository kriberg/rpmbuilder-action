# rpmbuilder-action

This action attempts to build RPM packages from specs within a reasonable build
environment. If you have a spec file tailored for creating well behaved
packages for el7 or el8, this github action might just be for you.

Currently, you can build packages for both el7 and el8, all using spectool to
download any source and yum-builddep for bootstrapping your build environment.

## Inputs

### `spectool`

Runs spectool to download any externally referenced sources. 

Default `"false"`

### `build_type`

Changes the build modes of rpmbuild. Use this to switch between `"bb"`, `"ba"`
etc for building binary packages only or for creating all RPM outputs.

Default `"bb"`

### `spec`

**Required** Path to the spec file you want to build.

Default `"SPECS/*.spec"`

### `source_dir`

Path to directory with any supplemental files you need to copy into the SOURCES
directory before building.

Default `"SOURCES/"`

### `output_dir`

Destination path for any produced RPM files. Directory will be created if it
does not exist and then all outputted packages will be copied into this
directory.

Default `"."`

## Outputs

### `rpm_files`

A list of RPM files produced, in the form of a space-separated string.

## Example usage

### Build a package for el7 using centos 7

```
name: Build package for less
on:
  push:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v2
      - name: clone repo
        run: |
          git clone https://src.fedoraproject.org/rpms/less.git
      - name: rpmbuilder
        id: rpmbuilder
        uses: evryfs/rpmbuilder-action/centos7@main
        with:
          spec: less/less.spec
          spectool: true
          build_type: bb
          source_dir: less
          output_dir: rpms
      - name: result
        run: |
          echo "Files built ${{ steps.rpmbuilder.outputs.rpm_files }}"
          for FILE in ${{ steps.rpmbuilder.outputs.rpm_files }}; do
            file $FILE
          done
```

To build for el8, just switch the action to `evryfs/rpmbuilder-action/centos8@main`.
