# VERSION   0.1
FROM        debian:unstable
MAINTAINER  Paul R. Tagliamonte <paultag@debian.org>

RUN apt-get update && apt-get install -y \
    python3.4 python3-pip \
    git \
    dpkg-dev devscripts

RUN mkdir -p /opt/pault.ag/
ADD . /opt/pault.ag/crank/
RUN python3.4 /usr/bin/pip3 install -e git://github.com/hylang/hy.git#egg=hy
RUN python3.4 /usr/bin/pip3 install -r /opt/pault.ag/crank/requirements.txt

WORKDIR /opt/pault.ag/crank/
