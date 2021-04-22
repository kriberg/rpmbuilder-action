VERSION ?= $(shell grep version pyproject.toml|head -n1|cut -d'"' -f2|xargs echo -n)

all: wheel images

wheel:
	poetry config cache-dir $(shell pwd)
	-rm -rf dist/*.whl
	poetry build

images:
	docker build --pull \
		--build-arg VERSION="$(VERSION)" \
		-f Dockerfile.centos7 \
		-t github-action-rpmbuild:centos7-latest \
		-t github-action-rpmbuild:centos7-$(VERSION) \
		-t quay.io/evryfs/github-action-rpmbuild:centos7-latest \
		-t quay.io/evryfs/github-action-rpmbuild:centos7-$(VERSION) \
		dist/
	docker build --pull \
		--build-arg VERSION="$(VERSION)" \
		-f Dockerfile.centos8 \
		-t github-action-rpmbuild:centos8-latest \
		-t github-action-rpmbuild:centos8-$(VERSION) \
		-t quay.io/evryfs/github-action-rpmbuild:centos8-latest \
		-t quay.io/evryfs/github-action-rpmbuild:centos8-$(VERSION) \
		dist/

push:
	docker push quay.io/evryfs/github-action-rpmbuild:centos7-latest
	docker push quay.io/evryfs/github-action-rpmbuild:centos7-$(VERSION)
	docker push quay.io/evryfs/github-action-rpmbuild:centos8-latest
	docker push quay.io/evryfs/github-action-rpmbuild:centos8-$(VERSION)

clean:
	docker rmi -f github-action-rpmbuild:centos7-latest | true
	docker rmi -f github-action-rpmbuild:centos8-latest | true