# K8s RBAC Example

## Usage

### Install prerequisites
`brew install kustomize kubectl httpie jq`

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

## Working on the Python code locally 

* Install Python using asdf or whatever method is most convenient for you 
* Install Pipenv (`pip install pipenv`)
* Reshim Python so `pipenv` is added to your path `asdf reshim python`
* Install the necessary dependencies (`pipenv install`)
* Run a shell configured with the necessary dependencies (`pipenv shell`)
* The docker baseimage (kennethreitz/pipenv) handles all this for you at build/deployment.

## Working on the Python code in Visual Studio Code

VS Code doesn't understand `pipenv` so you will need to run the following to install 
the necessary dependencies globally (or in the case of asdf locally to it's python install)

```
pip install bottle requests
```
