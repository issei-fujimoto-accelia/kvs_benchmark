#!/bin/sh
target_id=$1
# redis or memcache_text or memcache_binary
prot=$2

if [ $# -ne 2 ]; then
  echo "args: target_id: target container id, prot: protocol redis or memcache_text or memcache_binary"
  exit 1
fi

ip=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $target_id`
port=`docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}} {{end}}' $target_id`

echo $ip $port

docker run --rm --network=host \
       -v `pwd`/outputs:/outputs \
       redislabs/memtier_benchmark:latest \
       -s ${ip} -p ${port} -P ${prot} \
       --threads 4 -c 50 \
       --test-time=3600 --key-prefix=key1: —data-size=100 \
       --key-maximum=99999 \
       --key-minimum=10000 \
       --json-out-file="/outputs/"${prot}".json" \
       --out-file="/outputs/"${prot}".txt"



# docker run --rm --network=host redislabs/memtier_benchmark:latest \
#        -s 172.17.0.2 -p 11211 -P memcache_text \
#        --threads 4 -c 10000 \
#        --test-time=3600 --key-prefix=key1: —data-size=100 \
#        --key-maximum=99999 \
#        --key-minimum=10000 \
#        --wait-ratio=2:10 \
#        --out-file=${prot}"-result"

