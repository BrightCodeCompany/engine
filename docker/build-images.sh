#!/bin/bash

set -e

# Build alpine-jre image
docker build -f Dockerfile --target alpine-jre -t openintegrationengine/engine:latest-alpine-jre .
# Build ubuntu-jre image
docker build -f Dockerfile --target ubuntu-jre -t openintegrationengine/engine:latest-ubuntu-jre .

# Build alpine-jdk image
docker build -f Dockerfile --target alpine-jdk -t openintegrationengine/engine:latest-alpine-jdk .
# Build ubuntu-jdk image
docker build -f Dockerfile --target ubuntu-jdk -t openintegrationengine/engine:latest-alpine-jdk .