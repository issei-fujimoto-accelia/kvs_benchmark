#!/bin/sh
# docker run --rm --network=host --ulimit memlock=-1 docker.dragonflydb.io/dragonflydb/dragonfly
docker run --rm -p 6379:6379 --ulimit memlock=-1 docker.dragonflydb.io/dragonflydb/dragonfly
