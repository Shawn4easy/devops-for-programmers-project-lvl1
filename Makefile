# Инфраструктурные команды: всё, что вызывается снаружи контейнера.
# Команды самого приложения живут в app/Makefile и выполняются внутри образа.

build:
	docker compose build

setup: build
	docker compose run --rm app make setup

# Разработка: подхватывается override, приложение поднимается на localhost:8080.
dev:
	docker compose up

# Тесты: только базовый файл, без override, чтобы command был `make test`.
# --exit-code-from пробрасывает код возврата тестов наружу, это нужно для CI.
test:
	docker compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

down:
	docker compose down --remove-orphans

.PHONY: build setup dev test down
