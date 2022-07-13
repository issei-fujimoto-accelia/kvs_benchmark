#!/bin/sh

python3 graph.py -o t4_c30_r1000_p1.png -f ./outputs/df_t4_c30_r1000_p1.json ./outputs/redis_t4_c30_r1000_p1.json ./outputs/memcache_t4_c30_r1000_p1.json
python3 graph.py -o t4_c30_r10000_p1.png -f ./outputs/df_t4_c30_r10000_p1.json ./outputs/redis_t4_c30_r10000_p1.json ./outputs/memcache_t4_c30_r10000_p1.json
python3 graph.py -o t4_c30_r100000_p1.png -f ./outputs/df_t4_c30_r100000_p1.json ./outputs/redis_t4_c30_r100000_p1.json ./outputs/memcache_t4_c30_r100000_p1.json
python3 graph.py -o t4_c30_r1000000_p1.png -f ./outputs/df_t4_c30_r1000000_p1.json ./outputs/redis_t4_c30_r1000000_p1.json ./outputs/memcache_t4_c30_r1000000_p1.json


# python3 graph.py -o r1000_10000_100000_1000000.png -f ./outputs/df_t4_c30_r1000_p1.json  ./outputs/df_t4_c30_r10000_p1.json ./outputs/df_t4_c30_r100000_p1.json ./outputs/df_t4_c30_r1000000_p1.json 
