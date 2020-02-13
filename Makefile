.PHONY: deploy_production edit_image build_image push_image local_dry_run_deploy production_dry_run_deploy local_purge production_purge app deps compile

REGISTRY_HANDLE ?= $(shell whoami)
# tail to avoid capturing the output from compilation
APP_NAME ?= $(shell mix app.name | tail -n 1)
APP_VSN ?= $(shell mix app.version | tail -n 1)
IMAGE_TAG ?= $(REGISTRY_HANDLE)/$(APP_NAME):latest
BUILD ?= $(shell git rev-parse --short HEAD)

deps:
	mix deps.get

compile:
	mix compile

purge:
	kubectl delete namespaces rbac-example 

local_edit: 
	cd k8s/overlays/local; kustomize edit set image esl/pod-viewer=$(IMAGE_TAG)

local_deploy: local_edit build_image
	kustomize build k8s/overlays/local | kubectl apply -f -

local_dry_run_deploy:
	kustomize build k8s/overlays/local | kubectl apply --dry-run -f -

production_purge:
	kubectl delete namespaces rbac-example  

production_edit_image: 
	cd k8s/overlays/production; kustomize edit set image esl/pod-viewer=$(IMAGE_TAG)

production_deploy: production_edit_image
	kustomize build k8s/overlays/production | kubectl apply -f -

production_dry_run_deploy:
	kustomize build k8s/overlays/production | kubectl apply --dry-run -f -

build_image:
	docker build \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(IMAGE_TAG) .

push_image:
	docker push $(IMAGE_TAG)

port_forward_pod_viewer:
	kubectl port-forward --namespace rbac-example pod-viewer 8080:8080
