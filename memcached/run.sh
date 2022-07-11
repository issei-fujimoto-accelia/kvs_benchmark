#!/bin/sh
docker run --rm -p 11211:11211 memcached:1.6.15 memcached -t 4 -c 1024
