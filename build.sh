#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# enable interruption signal handling
trap - INT TERM

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
IMAGE_VERSION=0.1.0

docker build --no-cache -t kevinedwards/jenkins-master:${IMAGE_VERSION} ${SCRIPT_DIR}

cat > ${SCRIPT_DIR}/jenkins-master.sh <<EOF
#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# enable interruption signal handling
trap - INT TERM

docker run --rm -itd \
--name jenkins \
--env JAVA_OPTS=-Dhudson.footerURL=http://kevinedwards.ca \
-p 8080:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /vagrant/jenkins_home:/var/jenkins_home \
kevinedwards/jenkins-master:latest \
"\$@"
EOF

docker image tag "kevinedwards/jenkins-master:${IMAGE_VERSION}" "kevinedwards/jenkins-master:latest"

chmod +x ${SCRIPT_DIR}/jenkins-master.sh

