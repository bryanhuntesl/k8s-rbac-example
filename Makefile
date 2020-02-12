.PHONY: deploy_production edit_image build_image push_image local_dry_run_deploy production_dry_run_deploy local_purge production_purge

REGISTRY_HANDLE ?= $(shell whoami)

purge:
	kubectl delete namespaces rbac-example 

local_edit: 
	cd k8s/overlays/local; kustomize edit set image esl/pod-viewer=$(REGISTRY_HANDLE)/pod-viewer:latest

local_deploy: local_edit
	kustomize build k8s/overlays/local | kubectl apply -f -

local_dry_run_deploy:
	kustomize build k8s/overlays/local | kubectl apply --dry-run -f -

production_purge:
	kubectl delete namespaces rbac-example  

production_edit_image: 
	cd k8s/overlays/production; kustomize edit set image esl/pod-viewer=bryanhuntesl/pod-viewer:latest

production_deploy: production_edit_image
	kustomize build k8s/overlays/production | kubectl apply -f -

production_dry_run_deploy:
	kustomize build k8s/overlays/production | kubectl apply --dry-run -f -

build_image:
	docker build . -t $(REGISTRY_HANDLE)/pod-viewer:latest

push_image:
	docker push $(REGISTRY_HANDLE)/pod-viewer:latest

port_forward_pod_viewer:
	kubectl port-forward --namespace rbac-example pod-viewer 8080:8080