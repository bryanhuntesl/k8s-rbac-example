.PHONY: deploy_production edit_image build_image push_image local_dry_run_deploy production_dry_run_deploy local_purge production_purge app deps compile

APP_NAME ?= pod_viewer
BUILD ?= $(shell git rev-parse --short HEAD)
IMAGE_TAG ?= $(DOCKER_USERNAME)/$(APP_NAME):latest
IMAGE_TAG_GIT ?= $(DOCKER_USERNAME)/$(APP_NAME):$(BUILD)

check_registry_handle:
	if test "$(DOCKER_USERNAME)" = "" ; then \
			echo "DOCKER_USERNAME is not set"; \
			exit 1; \
	fi

deps: 
	mix deps.get

compile: deps
	mix compile

purge:
	kubectl delete namespaces rbac-example 

local_edit: check_registry_handle
	cd k8s/overlays/local; kustomize edit set image esl/pod-viewer=$(IMAGE_TAG)

local_deploy: local_edit build_image
	kustomize build k8s/overlays/local | kubectl apply -f -

local_dry_run_deploy:
	kustomize build k8s/overlays/local | kubectl apply --dry-run -f -

production_purge:
	kubectl delete namespaces rbac-example  

production_edit_image: check_registry_handle
	cd k8s/overlays/production; kustomize edit set image esl/pod-viewer=$(IMAGE_TAG)

production_deploy: production_edit_image
	kustomize build k8s/overlays/production | kubectl apply -f -

production_dry_run_deploy:
	kustomize build k8s/overlays/production | kubectl apply --dry-run -f -

build_image: check_registry_handle
	docker build \
		--build-arg APP_NAME=$(APP_NAME) \
		-t $(IMAGE_TAG) \
		-t $(IMAGE_TAG_GIT) .

push_image: check_registry_handle
	docker push $(IMAGE_TAG)

port_forward_pod_viewer:
	kubectl port-forward --namespace rbac-example pod-viewer 8080:8080
