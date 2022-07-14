#!/bin/bash
benchmark() {
  port=$1
  prot=$2
  threads=$3
  clients=$4
  # test_time=$5
  request_num=$5
  pipeline=$6
  output_file=$7

  # ip=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $target_id`
  ip="10.0.1.5"
  # port=`docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}} {{end}}' $target_id`

  echo $ip $port

  output=${output_file}_t${threads}_c${clients}_r${request_num}_p${pipeline}
  echo $output

  docker run --rm --network=host \
	 -v `pwd`/outputs:/outputs \
	 redislabs/memtier_benchmark:latest \
	 -s ${ip} -p ${port} -P ${prot} \
	 --threads ${threads} -c ${clients} -n ${request_num} \
	 --distinct-client-seed \
	 --hide-histogram \
	 --pipeline=${pipeline} \
	 —data-size=10 \
	 --json-out-file="/outputs/"${output}".json" \
	 --out-file="/outputs/"${output}".txt" \
  	 --ratio="1:0"
}


run_redis() {
  threads=$1
  clients=$2
  req_num=$3
  pipeline=$4
  benchmark 6379 "redis" ${threads} ${clients} ${req_num}  ${pipeline} "redis"
}
run_mem() {
  threads=$1
  clients=$2
  req_num=$3
  pipeline=$4
  benchmark 11211 "memcache_text" ${threads} ${clients} ${req_num} ${pipeline} "memcache"
}
run_df() {
  threads=$1
  clients=$2
  req_num=$3
  pipeline=$4
  benchmark 6380 "redis" ${threads} ${clients} ${req_num}  ${pipeline} "df"
}


run_redis 4 30 1000 10
run_redis 4 30 10000 10
run_redis 4 30 100000 10
run_redis 4 30 1000000 10

run_mem 4 30 1000 10
run_mem 4 30 10000 10
run_mem 4 30 100000 10
run_mem 4 30 1000000 10

run_df 4 30 1000 10
run_df 4 30 10000 10
run_df 4 30 100000 10
run_df 4 30 1000000 10
