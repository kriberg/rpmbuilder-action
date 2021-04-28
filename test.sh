BUILDER="buildah bud" make 
podman run --rm -it -v $(pwd):/github/workspace -w /github/workspace \
    -e INPUT_BUILD_TYPE=ba \
    -e INPUT_OUTPUT_DIR=rpms \
	-e INPUT_SOURCE_DIR=less \
    -e INPUT_SPECTOOL=1 \
    -e INPUT_SPEC=less/less.spec \
    evryfs/github-actions-rpmbuilder:centos8-1.0.0 
