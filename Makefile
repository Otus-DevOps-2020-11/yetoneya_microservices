SHELL = /bin/sh
UNAME ?= yetoneya
TAG ?= 1.1

.PHONY: build push

build: build_comment build_post build_ui build_prometheus build_blackbox

build_comment:
		docker build -t  $(UNAME)/comment:$(TAG) src/comment
build_post:
		docker build -t $(UNAME)/post:$(TAG) src/post-py
build_ui:
		docker build -t $(UNAME)/ui:$(TAG) src/ui
build_prometheus:
		docker build -t $(UNAME)/prometheus:$(TAG) monitoring/prometheus
build_blackbox:
		docker build  -t $(UNAME)/blackbox:$(TAG) monitoring/blackbox_exporter

push: push_comment push_post push_ui push_prometheus push_blackbox

push_comment:
		docker login
		docker push  $(UNAME)/comment:$(TAG)
push_post:
		docker login
		docker push $(UNAME)/post:$(TAG)
push_ui:
		docker login
		docker push $(UNAME)/ui:$(TAG)
push_prometheus:
		docker login
		docker push $(UNAME)/prometheus:$(TAG)
push_blackbox:
		docker login
		docker push $(UNAME)/blackbox:$(TAG)
