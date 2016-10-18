FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get install -y git python3-pip curl
RUN python3 -m pip install --upgrade pip pytest-cov nbval numpy

WORKDIR /usr/local

RUN git clone https://github.com/joommf/joommfutil.git

WORKDIR /usr/local/joommfutil