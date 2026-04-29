.PHONY: up build shell down ps logs

up:
	docker compose up -d workspace

build:
	docker compose up -d --build workspace

shell:
	docker compose exec workspace zsh

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f workspace
