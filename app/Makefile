setup: install db-migrate

# Автопроверка Hexlet вызывает эту цель вне контейнера, на голом раннере с
# одним лишь node, поэтому pnpm при отсутствии ставится на месте. Внутри
# образа он уже глобальный, и проверка ничего не делает.
install:
	command -v pnpm >/dev/null 2>&1 || npm install -g pnpm@11.20.0
	pnpm install

db-migrate:
	pnpm run db:generate

build:
	pnpm run build

prepare-env:
	cp -n .env.example .env

start:
	NODE_ENV=production pnpm run start

dev:
	pnpm exec concurrently "make start-frontend" "make start-backend"

start-backend:
	npm start -- --watch --verbose-watch --ignore-watch='node_modules .git .sqlite'

start-frontend:
	pnpm exec webpack --watch --progress

lint:
	pnpm --silent run lint
	pnpm --silent run format:check

lint-fix:
	pnpm --silent run lint:fix

test:
	NODE_ENV=test pnpm --silent test
