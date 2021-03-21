SHELL=/bin/sh

.PHONY: build push

build: build_comment build_post build_ui build_prometheus build_blackbox

build_comment:
		docker build -t  yetoneya/comment:1.1 src/comment
build_post:
		docker build -t yetoneya/post:1.1 src/post-py
build_ui:
		docker build -t yetoneya/ui:1.1 src/ui
build_prometheus:
		docker build -t yetoneya/prometheus:1.1 monitoring/prometheus
build_blackbox:
		docker build  -t yetoneya/blackbox:1.1 monitoring/blackbox_exporter

push: push_comment push_post push_ui push_prometheus push_blackbox

push_comment:
		docker login
		docker push  yetoneya/comment:1.1
push_comment:
		docker login
		docker push yetoneya/post:1.1
push_ui:
		docker login
		docker push yetoneya/ui:1.1
push_prometheus:
		docker login
		docker push yetoneya/prometheus:1.1
push_blackbox:
		docker login
		docker push yetoneya/blackbox:1.1

