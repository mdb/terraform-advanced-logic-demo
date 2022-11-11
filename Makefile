grafana:
	docker-compose up
.PHONY: grafana

tf-init:
	terraform init

tf-plan: tf-init
	terraform plan
