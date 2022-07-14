#!/bin/bash
benchmark() {
  target_id=$1
  prot=$2
  threads=$3
  clients=$4
  # test_time=$5
  request_num=$5
  pipeline=$6 
  output_file=$7  
  
  # ip=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $target_id`
  ip="127.0.0.1"
  port=`docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}} {{end}}' $target_id`

  echo $ip $port

  output=${output_file}_t${threads}_c${clients}_t${request_num}_p${pipeline}
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
  id=$1
  threads=$2
  clients=$3
  req_num=$4
  pipeline=$5
  benchmark ${id} "redis" ${threads} ${clients} ${req_num}  ${pipeline} "redis"
}
run_mem() {
  id=$1
  threads=$2
  clients=$3
  req_num=$4
  pipeline=$5
  benchmark ${id} "memcache_text" ${threads} ${clients} ${req_num}  ${pipeline} "memcache"
}
run_df() {
  id=$1
  threads=$2
  clients=$3
  req_num=$4
  pipeline=$5
  benchmark ${id} "redis" ${threads} ${clients} ${req_num}  ${pipeline} "df"
}


redis_id=`docker ps -aqf "name=^redis$"`
mem_id=`docker ps -aqf "name=^memcached$"`
df_id=`docker ps -aqf "name=^dragonfly$"`


# run_redis ${redis_id} 4 30 1000 1
# run_redis ${redis_id} 4 30 10000 1
# run_redis ${redis_id} 4 30 100000 1
# run_redis ${redis_id} 4 30 1000000 1

# run_mem ${mem_id} 4 30 1000 1
# run_mem ${mem_id} 4 30 10000 1
# run_mem ${mem_id} 4 30 100000 1
# run_mem ${mem_id} 4 30 1000000 1

# run_df ${df_id} 4 30 1000 1
# run_df ${df_id} 4 30 10000 1
# run_df ${df_id} 4 30 100000 1
# run_df ${df_id} 4 30 1000000 1

