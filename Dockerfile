FROM csanchez/jenkins-swarm-slave
MAINTAINER Christophe Labouisse <christophe@labouisse.org>
USER root

RUN apt-get update && apt-get install -y git bzip2 && rm -rf /var/lib/apt/lists

RUN wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker \
  && chmod +x /usr/local/bin/docker

# Grab gosu
RUN wget 'https://github.com/tianon/gosu/releases/download/1.1/gosu' -O /usr/local/bin/gosu \
  && chmod +x /usr/local/bin/gosu

RUN ls -al /usr/local/bin

# Replace the original jenkins-slave.sh by my hacked version.
COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh
