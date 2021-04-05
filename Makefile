SHELL:=/bin/bash

# Colors
Color_Off=\033[0m
Red=\033[0;31m
Cyan=\033[0;36m
BRed=\033[1;31m
BCyan=\033[1;36m

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

build:  ## Сборка проекта
	@echo -e '${Cyan}Сборка проекта${Color_Off}'
	@docker-compose build

start:  ## Запуск проекта
	@docker-compose up tarantool

stop:  ## Остановка проект
	@docker-compose down

test:  ## Запуск тестов
	@docker-compose up tests && docker-compose down

.PHONY: help, build, start, stop, test
.DEFAULT_GOAL := help
