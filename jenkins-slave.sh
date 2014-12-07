#!/bin/bash

# if `docker run` first argument start with `-` the user is passing jenkins swarm launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then

  # Hack: add jenkins-slave to the docker socket group.
  if [ -e /var/run/docker.sock ]; then
    SOCKET_GROUP=$(ls -l /var/run/docker.sock | cut -d ' ' -f 4)
    if [[ $SOCKET_GROUP =~ ^[0-9][0-9]*$ ]]; then
      groupadd -g $SOCKET_GROUP docker
    fi
    usermod -a -G $SOCKET_GROUP jenkins-slave
  fi

  # jenkins swarm slave
  JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

  # if -master is not provided and using --link jenkins:jenkins
  if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
    PARAMS="-master http://$JENKINS_PORT_8080_TCP_ADDR:$JENKINS_PORT_8080_TCP_PORT"
  fi

  # Add system property to put the temporary file under the sharable volume
  # TODO do not set if java.io.tmpdir has already been defined
  JAVA_OPTS="$JAVA_OPTS -Djava.io.tmpdir=$HOME/tmp"

  # set the oki-docki.running.from.container properties
  if [[ ! -z "$JENKINS_NAME" ]]; then
    NAMES=(${JENKINS_NAME//\// })
    JAVA_OPTS="$JAVA_OPTS -Doki-docki.running.from.container=${NAMES[0]}"
  fi

  echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
  exec gosu jenkins-slave java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
