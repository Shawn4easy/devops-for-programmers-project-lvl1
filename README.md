# Упаковка в Docker Compose

[![Actions Status](https://github.com/Shawn4easy/devops-for-programmers-project-lvl1/workflows/hexlet-check/badge.svg)](https://github.com/Shawn4easy/devops-for-programmers-project-lvl1/actions)
[![Push](https://github.com/Shawn4easy/devops-for-programmers-project-lvl1/actions/workflows/push.yml/badge.svg)](https://github.com/Shawn4easy/devops-for-programmers-project-lvl1/actions/workflows/push.yml)

Блог на Fastify, упакованный в Docker Compose: приложение, PostgreSQL и Caddy
в роли обратного прокси.

## Образ на Docker Hub

[`shawn4easy/devops-for-programmers-project-lvl1`](https://hub.docker.com/r/shawn4easy/devops-for-programmers-project-lvl1)

Собирается из `Dockerfile.production` и публикуется с тегом `latest` на каждый
push в `main`.

```bash
docker run -p 8080:8080 -e NODE_ENV=development \
  shawn4easy/devops-for-programmers-project-lvl1 make dev
```

## Требования

* Docker 20.10 и новее
* Docker Compose 1.27 и новее (нужна актуальная спецификация compose-файлов)
* GNU Make
* Свободные порты 80, 443 и 8080

Node.js на машине не нужен: все команды выполняются внутри контейнеров.

## Структура

| Путь | Назначение |
| --- | --- |
| `app/` | исходники приложения и его собственный `Makefile` |
| `Dockerfile` | образ для разработки, код монтируется томом |
| `Dockerfile.production` | production-образ, код копируется внутрь |
| `docker-compose.yml` | тесты и production-сборка |
| `docker-compose.override.yml` | локальная разработка |
| `services/caddy/Caddyfile` | конфигурация обратного прокси |

Команды в корневом `Makefile` — инфраструктурные, они вызываются снаружи
контейнеров. Команды самого приложения живут в `app/Makefile` и выполняются
внутри образа.

## Запуск

Установка зависимостей и миграции:

```bash
make setup
```

Запуск для разработки:

```bash
make dev
```

Приложение поднимается на [https://localhost](https://localhost) через Caddy,
который сам выпускает самоподписанный сертификат и перенаправляет http на
https. Напрямую, минуя прокси, оно доступно на
[http://localhost:8080](http://localhost:8080).

Остановить и удалить контейнеры:

```bash
make down
```

## Тесты

```bash
make ci
```

Тесты выполняются внутри контейнера на production-образе и на PostgreSQL —
ровно так же, как в CI. Код берётся из образа, а не с хоста, база поднимается
сервисом `db` и удаляется вместе со стеком. Код возврата тестов пробрасывается
наружу, поэтому команда годится и для локального прогона, и для пайплайна.

`make test` — псевдоним для `make ci`.

## Переменные окружения

Приложение настраивается через окружение. Для Compose значения заданы в
`docker-compose.yml`, для запуска вне контейнеров их можно положить в `.env`,
скопировав `app/.env.example`. Сам `.env` в репозиторий не попадает.

| Переменная | Назначение |
| --- | --- |
| `DATABASE_CLIENT` | диалект базы: `postgres` или `sqlite` |
| `DATABASE_HOST` | хост базы, в Compose это `db` |
| `DATABASE_PORT` | порт базы |
| `DATABASE_NAME` | имя базы |
| `DATABASE_USERNAME` | пользователь |
| `DATABASE_PASSWORD` | пароль |
| `DATABASE_URL` | строка подключения целиком, вместо частей выше |

## CI

`.github/workflows/push.yml` на каждый push в `main` прогоняет тесты через
Docker Compose и, если они прошли, публикует production-образ на Docker Hub.
Для публикации нужны секреты репозитория `DOCKERHUB_USERNAME` и
`DOCKERHUB_TOKEN`.
