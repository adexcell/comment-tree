.PHONY: help run test lint migrate-up migrate-down migrate-create docker-up docker-down clean

DB_URL := postgres://admin:admin@localhost:5432/commenttree?sslmode=disable

help: ## Показать справку
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

run: ## Запустить приложение
	go run cmd/api/main.go

test: ## Запустить тесты
	go test -v -race -cover ./...

lint: ## Запустить линтер
	golangci-lint run --timeout 5m

migrate-up: ## Применить миграции
	migrate -path migrations -database "$(DB_URL)" up

migrate-down: ## Откатить последнюю миграцию
	migrate -path migrations -database "$(DB_URL)" down 1

migrate-create: ## Создать новую миграцию (использование: make migrate-create name=add_users)
	migrate create -ext sql -dir migrations -seq $(name)

docker-up: ## Запустить docker-compose
	docker-compose up -d

docker-down: ## Остановить docker-compose
	docker-compose down

clean: ## Очистить бинарники и кеш
	go clean
	rm -rf bin/

.DEFAULT_GOAL := help
