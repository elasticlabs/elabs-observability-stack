# Set default no argument goal to help
.DEFAULT_GOAL := help

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# For cleanup, get Compose project name from .env file
DC_PROJECT?=$(shell cat .env | sed 's/.*=//')
GRAFANA_URL?=$(shell cat .env | grep GRAFANA_VHOST | sed 's/.*=//')
CURRENT_DIR?= $(shell pwd)

# Every command is a PHONY, to avoid file naming confliction.
.PHONY: help
help:
	@echo "==================================================================================="
	@echo "              Grafa based observability docker composition "
	@echo "         https://github.com/elasticlabs/elabs-observability-stack "
	@echo " "
	@echo "Hints for developers:"
	@echo "  make build         # Makes container & volumes cleanup, and builds TEAMEngine"
	@echo "  make up            # With working proxy, brings up the testing infrastructure"
	@echo "  make update        # Update the whole stack"
	@echo "  make hard-cleanup  # Hard cleanup of images, containers, networks, volumes & data"
	@echo "==================================================================================="

.PHONY: up
up: 
	@bash ./.utils/message.sh info "[INFO] Bringing up the Grafana stack"
	# Set server_name in reverse proxy and grafana config file
	sed -i "s/changeme/$(GRAFANA_URL)/" ./proxy/grafana-stack.conf
	sed -i "s/changeme/$(GRAFANA_URL)/" ./grafana/grafana.ini

	@bash ./.utils/message.sh info "[INFO] The following URL is detected : $(GRAFANA_URL). It should be reachable for proper operation"
	nslookup $(GRAFANA_URL) && echo "        -> nslookup OK!"

	git stash && git pull
	docker-compose -f docker-compose.yml up -d --build --remove-orphans

.PHONY: build
build:
	@bash ./.utils/message.sh info "[INFO] Building the Grafana stack"
	# Set server_name in reverse proxy
	sed -i "s/changeme/$(GRAFANA_URL)/" ./proxy/grafana-stack.conf 

	docker-compose -f docker-compose.yml build
 
.PHONY: update
update: 
	docker-compose -f docker-compose.yml pull
	docker-compose -f docker-compose.yml up -d --build 	

.PHONY: hard-cleanup
hard-cleanup:
	@echo "[INFO] Bringing down the Grafana stack"
	docker-compose -f docker-compose.yml down --remove-orphans
	# 2nd : clean up all containers & images, without deleting static volumes
	@echo "[INFO] Cleaning up containers & images"
	docker system prune -a

.PHONY: urls
urls:
	@bash ./.utils/message.sh headline "[INFO] You may now access your project at the following URLs:"
	@bash ./.utils/message.sh link "Grafana:  https://${GRAFANA_URL}/grafana"
	@echo ""

.PHONY: wait
wait: 
	sleep 5
