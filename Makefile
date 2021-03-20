SHELL=/bin/sh
TAG=make
USERNAME=yetoneya

all: build push

#build

build:  build_comment build_post build_ui build_prometheus build_blackbox

build_comment:
        docker build -t $(USERNAME)/comment:$(TAG) src/comment

build_post:
        docker build -t $(USERNAME)/post:$(TAG) src/post-py

build_ui:
        docker build -t $(USERNAME)/ui:$(TAG) src/ui

build_prometheus:
        docker build -t $(USERNAME)/prometheus:$(TAG) monitoring/prometheus

build_blackbox:
        docker build -t $(USERNAME)/blackbox:$(TAG) monitoring/blackbox

#push

push: push_comment push_post push_ui push_prometheus push_blackbox

push_comment:
        docker push $(USERNAME)/comment:$(TAG)

push_comment:
        docker push $(USERNAME)/post:$(TAG)

push_ui:
        docker push $(USERNAME)/ui:$(TAG)

push_prometheus:
        docker push $(USERNAME)/prometheus:$(TAG)

push_blackbox:
        docker push $(USERNAME)/blackbox:$(TAG)

