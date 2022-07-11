#!/bin/sh
# docker build -t redis:kvs_test .
docker run --rm -p 6379:6379 -v `pwd`/conf:/usr/local/etc/redis redis:kvs_test redis-server /usr/local/etc/redis/redis.conf
# docker run --rm -p 6379:6379 redis:bullseye

