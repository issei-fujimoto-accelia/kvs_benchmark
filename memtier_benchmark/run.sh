#!/bin/sh
target_id=$1
# redis or memcache_text or memcache_binary
prot=$2
output_file=$3

threads=$4
connectins=$5
time=$5

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
       --threads 4 -c 20 \
       --test-time=120 \
       --distinct-client-seed \
       --hide-histogram \
       --pipeline=10 \
       —data-size=256 \
       --json-out-file="/outputs/"${output_file}".json" \
       --out-file="/outputs/"${output_file}".txt"


# ## for simple test!!!
# docker run --rm --network=host \
#        -v `pwd`/outputs:/outputs \
#        redislabs/memtier_benchmark:latest \
#        -s ${ip} -p ${port} -P ${prot} \
#        --threads 4 -c 5 \
#        -d 256 -n 10 \
#        --json-out-file="/outputs/"${prot}".json" \
#        --out-file="/outputs/"${prot}".txt"

       #--test-time=10 --key-prefix=key1: —data-size=10 \
