#!/bin/sh
image_name="python:plt"

id=`docker image ls -q ${image_name}`
echo $id
if [ "$id" = "" ]; then
  docker build -t python:plt .  
fi

output=$1
files=${@:2}
docker run --rm -it -v `pwd`/:/work python:plt python graph.py -o ${output} -f ${files}



