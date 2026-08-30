# Инфраструктурные команды: всё, что вызывается снаружи контейнера.
# Команды самого приложения живут в app/Makefile и выполняются внутри образа.

build:
	docker compose build

setup: build
	docker compose run --rm app make setup

# Разработка: подхватывается override, приложение поднимается на localhost:8080.
dev:
	docker compose up

# Тесты: только базовый файл, без override, чтобы command был `make test`,
# а код собирался в образ, а не подкладывался томом с хоста.
# --exit-code-from пробрасывает код возврата тестов наружу, без него CI зелёный
# при любом результате.
ci:
	docker compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

# Локальный псевдоним для ci: снаружи привычнее набирать make test.
test: ci

# Собирает production-образ и отправляет его на Docker Hub с тегом latest.
# Тег берётся из секции image в docker-compose.yml.
push:
	docker compose -f docker-compose.yml build app
	docker compose -f docker-compose.yml push app

down:
	docker compose down --remove-orphans

.PHONY: build setup dev ci test push down
