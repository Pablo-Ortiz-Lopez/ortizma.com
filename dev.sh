#!/bin/bash

if [ "$(docker images -q hugo)" = "" ] || [ "$1" = "build" ]; then
    docker build -t hugo .
    if [ "$1" = "build" ]; then
        shift
    fi
fi

docker run --rm \
    -it \
    -v $(pwd):/src \
    -p 81:80 \
    --name blog-server \
    hugo \
    hugo server --bind=0.0.0.0 --port=80