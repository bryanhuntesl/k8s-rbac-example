# K8s RBAC Example

## Usage

### Install prerequisites
`brew install kustomize kubectl httpie jq`

### Set your dockerhub username as an environmental variable

In order to push your images you will need a dockerhub account and to set the
environment variable `DOCKER_USERNAME` to this name e.g.

```
export DOCKER_USERNAME=yourdockerhubusername
```

### Use Makefile targets

The Makefile contains a number of targets, they are :

* `purge` : delete the namespace
* `local_edit` : replace esl/pod-viewer image name with your own
* `local_deploy` : deploy using 'local' overlay - intended for local deployment
* `local_dry_run_deploy` : verify the local deployment is syntatically valid
* `production_purge` : same as `rbac-example` TODO
* `production_edit_image` : as for local variant above
* `production_deploy` : as for local variant above
* `production_dry_run_deploy` : as for local variant above
* `build_image` : build the container image and tag <your username>/pod-viewer:latest
* `push_image` : push <your username>/pod-viewer:latest to docker hub
* `port_forward_pod_viewer` : port forward the pod viewer to localhost:8080 - for curl/http commands

## Using selectors

### Field selector

#### HTTPie

    http http://localhost:8080/reader/v1/pods fieldSelector==metadata.name=baz

#### CURL

    curl 'http://localhost:8080/reader/v1/pods?fieldSelector=metadata.name%3Dbaz'

### Label selector

#### HTTPie

    http http://localhost:8080/reader/v1/pods labelSelector==environment=dev

#### CURL

    curl 'http://localhost:8080/reader/v1/pods?labelSelector=environment%3Ddev'
