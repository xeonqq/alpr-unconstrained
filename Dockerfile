FROM tensorflow/tensorflow AS base
MAINTAINER Qian Qian (xeonqq@gmail.com)

RUN apt-get update
RUN apt-get install -y wget

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get install -y python3-opencv

