grafana:
	docker-compose up --detach
.PHONY: grafana

tf-init:
	terraform init

tf-plan: tf-init
	terraform plan
