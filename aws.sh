#!/usr/bin/env bash

IMAGE='aws-cli-v2'

build() {
  local dockerfile='https://raw.githubusercontent.com/clcollins/aws-cli-container/master/Dockerfile'

  curl ${dockerfile} | podman build -t ${IMAGE} -f - .
}

aws2() {

  if ! podman images | grep localhost/aws-cli-v2 > /dev/null
  then
    build
  fi

  podman run --rm -it ${IMAGE} "${@}"
}

if [[ "${1}" == "build-image" ]]
then
  build
  exit
fi

aws2 "$@"

