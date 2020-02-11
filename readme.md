# K8s RBAC Example

## Usage

1. Clone repo
2. Apply Kubernetes definitions

        % kubectl apply -f k8s

3. Get service port

        % minikube service pod-viewer --url
        http://192.168.64.2:30884

4. List the pods

        http http://192.168.64.2:30884/reader/v1/pods


## Using selectors

### Field selector

#### HTTPie

    http http://192.168.64.2:30884/reader/v1/pods fieldSelector==metadata.name=baz

#### CURL

    curl 'http://192.168.64.2:30884/reader/v1/pods?fieldSelector=metadata.name%3Dbaz'

### Label selector

#### HTTPie

    http http://192.168.64.2:30884/reader/v1/pods labelSelector==environment=dev

#### CURL

    curl 'http://192.168.64.2:30884/reader/v1/pods?labelSelector=environment%3Ddev'
