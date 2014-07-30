# VERSION   0.1
FROM        debian:unstable
MAINTAINER  Paul R. Tagliamonte <paultag@hylang.org>

RUN apt-get update && apt-get install -y \
    python3.4 \
    python3-pip \
    python3-distro-info \
    python3-setuptools \
    python-setuptools \
    python-dput \
    dput-ng \
    git \
    dpkg-dev \
    devscripts

RUN mkdir -p /opt/pault.ag/
ADD . /opt/pault.ag/crank/
ADD bin/crank /usr/bin/crank

RUN python3.4 /usr/bin/pip3 install -e \
        git://git.debian.org/collab-maint/dputng.git#egg=dput

RUN python3.4 /usr/bin/pip3 install -e \
        git://github.com/hylang/hy.git#egg=hy

RUN python3.4 /usr/bin/pip3 install -r \
        /opt/pault.ag/crank/requirements.txt

ENV CRANK_HOME /crank/
WORKDIR /opt/pault.ag/crank/
ENTRYPOINT ["/usr/bin/crank"]
