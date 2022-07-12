FROM python:3.9-alpine

RUN mkdir -p /work
COPY requirements.txt /work
WORKDIR /work

RUN apk add g++ jpeg-dev zlib-dev libjpeg make
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install -r requirements.txt

