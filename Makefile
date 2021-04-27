VERSION ?= 0.1.0
BUILDER ?= docker build

all: images

images:
	$(BUILDER) --pull \
		-f Dockerfile.centos7 \
		-t evryfs/github-actions-rpmbuilder:centos7-latest \
		-t evryfs/github-actions-rpmbuilder:centos7-$(VERSION) \
		-t quay.io/evryfs/github-actions-rpmbuilder:centos7-latest \
		-t quay.io/evryfs/github-actions-rpmbuilder:centos7-$(VERSION) \
		.
	$(BUILDER) --pull \
		-f Dockerfile.centos8 \
		-t evryfs/github-actions-rpmbuild:centos8-latest \
		-t evryfs/github-actions-rpmbuild:centos8-$(VERSION) \
		-t quay.io/evryfs/github-actions-rpmbuilder:centos8-latest \
		-t quay.io/evryfs/github-actions-rpmbuilder:centos8-$(VERSION) \
		.

push:
	docker push quay.io/evryfs/github-actions-rpmbuilder:centos7-latest
	docker push quay.io/evryfs/github-actions-rpmbuilder:centos7-$(VERSION)
	docker push quay.io/evryfs/github-actions-rpmbuilder:centos8-latest
	docker push quay.io/evryfs/github-actions-rpmbuilder:centos8-$(VERSION)

clean:
	docker rmi -f evryfs/github-actions-rpmbuilder:centos7-latest | true
	docker rmi -f evryfs/github-actions-rpmbuilder:centos8-latest | true
