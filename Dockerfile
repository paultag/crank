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

RUN python3.4 /usr/bin/pip3 install -e \
        git://git.debian.org/collab-maint/dputng.git#egg=dput

RUN python3.4 /usr/bin/pip3 install -e \
        git://github.com/hylang/hy.git#egg=hy

COPY requirements.txt /opt/pault.ag/crank/
WORKDIR /opt/pault.ag/crank
RUN python3.4 /usr/bin/pip3 install -r requirements.txt

COPY bin/crank /usr/bin/crank
ENV CRANK_HOME /crank/

# add a user to run crank as, for better safeness
RUN groupadd user && useradd -g user user
RUN mkdir -p "$CRANK_HOME" && chown -R user:user "$CRANK_HOME"
USER user
ENV HOME /home/user

ENTRYPOINT ["/usr/bin/crank"]
CMD []

COPY . /opt/pault.ag/crank
