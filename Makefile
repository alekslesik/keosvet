# Include variables from the .envrc file
#include .envrc

#=====================================#
# HELPERS #
#=====================================#

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]


#=====================================#
# DOCKER #
#=====================================#

## run: Exec docker-up
.PHONY: run
up: docker-up

## docker-up: Build images before starting containers; Create and start containers
.PHONY: docker-up
docker-up:
	docker compose up --build -d

## docker-down: Stop and remove containers, networks; Remove containers for services not defined in the Compose file.
.PHONY: docker-down
docker-down:
	docker compose down --remove-orphans

## mysql-up: Build bitrix-mysql image before starting containers; Create and start containers
.PHONY: mysql-up
mysql-up:
	docker compose up --build -d mysql

## mysql-exec: Start bin/sh in bitrix-mysql
.PHONY: mysql-exec
mysql-exec:
	docker container exec -it bitrix-mysql sh

## php-up: Build php-apache image before starting containers; Create and start containers
.PHONY: php-up
php-up:
	docker compose up --build -d php-apache

## php-exec: Start bin/sh in php-docker
.PHONY: php-exec
php-exec:
	docker container exec -it bitrix-php-apache sh

bitrix-setup:
	docker container exec bitrix-php-apache wget http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php -O bitrixsetup.php
	# make perm

bitrix-restore-download:
	docker container exec bitrix-php-apache wget $(url)
	make perm

bitrix-restore: bitrix-restore-download
	docker-compose exec bitrix-php-apache wget http://www.1c-bitrix.ru/download/scripts/restore.php -O restore.php
	make perm

composer:
	docker-compose exec bitrix-php-apache composer install

perm:
	sudo chgrp -R ${USER} www
	sudo chown -R ${USER}:${USER} www
	sudo chmod -R ug+rwx www
