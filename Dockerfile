# Образ для разработки. Файлы внутрь не копируются: код приезжает томом
# ./app:/app из docker-compose.override.yml, а зависимости ставятся отдельным
# шагом `make setup` в том /app/node_modules. Копирование в образ живёт только
# в Dockerfile.production.
FROM node:26-slim

# corepack из образов Node 26 убран, поэтому pnpm ставится напрямую. Версия
# берётся из поля packageManager, чтобы образ и разработка совпадали.
RUN npm install -g pnpm@11.20.0

# make нужен для команд приложения из app/Makefile.
# python3 и g++ — для better-sqlite3: он компилируется из исходников на
# `make setup`, а установка здесь идёт в примонтированный том, не в образ.
RUN apt-get update && apt-get install -y --no-install-recommends \
      make python3 g++ \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["make", "dev"]
