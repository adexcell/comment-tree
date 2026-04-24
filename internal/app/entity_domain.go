package app

import (
	"github.com/adexcell/comment-tree/internal/entity/adapter/postgres"
	"github.com/adexcell/comment-tree/internal/entity/adapter/rabbit"
	"github.com/adexcell/comment-tree/internal/entity/adapter/redis"
	httprouter "github.com/adexcell/comment-tree/internal/entity/controller/http_router"
	"github.com/adexcell/comment-tree/internal/entity/usecase"
)

func EntityDomain(d Dependencies) {
	entityUseCase := usecase.New(
		postgres.New(d.Postgres),
		redis.New(d.Redis),
		rabbit.New(d.RabbitMQ),
	)

	httprouter.EntityRouter(d.RouterHTTP, entityUseCase, d.Metrics)
}
