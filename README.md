aws-cli-container
=================

The AWS CLI version 2, containerized.

Build and Install
-----------------
This install can be built and run without root access using Podman. 

```sh
# build
podman build -t aws-cli-v2 -f Dockerfile .

# run
podman run -it aws-cli-v2 "--version"
```

CLI Compatibility
-----------------

The following function can be added to your `.bashrc` to run the client the same way it would be run if installed as normal:

```sh
aws2() {
  local image='localhost/aws-cli-v2'
  local dockerfile='https://raw.githubusercontent.com/clcollins/aws-cli-container/master/Dockerfile'

  if ! podman images | grep ${image} > /dev/null
  then
    curl ${dockerfile} | podman build -t ${image} -f - .
  fi

  podman run --rm -it ${image} "${@}"
}
```
