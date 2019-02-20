#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# enable interruption signal handling
trap - INT TERM

docker run --rm -itd --name jenkins --env JAVA_OPTS=-Dhudson.footerURL=http://kevinedwards.ca -p 8080:8080 -p 50000:50000 -v /vagrant/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock kevinedwards/jenkins-master:latest "$@"
