# Jenkins swarm slave with Docker support

A [Jenkins swarm](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin) slave with support the docker command.

**This is really experimental**

## Running

The image is based on [`csanchez/jenkins-swarm-slave`](https://registry.hub.docker.com/u/csanchez/jenkins-swarm-slave/) and is used similarly:

To run a Docker container passing [any parameters](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin#SwarmPlugin-AvailableOptions) to the slave

    docker run csanchez/jenkins-swarm-slave -master http://jenkins:8080 -username jenkins --password jenkins -executors 1

Linking to the Jenkins master container there is no need to use `--master`

    docker run -d --name jenkins -p 8080:8080 csanchez/jenkins-swarm
    docker run -d --link jenkins:jenkins csanchez/jenkins-swarm-slave -username jenkins -password jenkins -executors 1

### Communication with Docker daemon

Depending on your installation you might want to use either the unix socket or tcp/ip.

#### Unix socket

You should map the socket from the host server into the container:

    docker run -v /var/run/docker.sock:/var/run/docker.sock

#### TCP/IP

TODO

# Building

    docker build -t jenkins-swarm-slave-docker .
