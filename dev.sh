#!/bin/bash
docker run --rm \
    -it \
    -v $(pwd):/src \
    -p 81:1313 \
    klakegg/hugo:0.101.0 \
    server