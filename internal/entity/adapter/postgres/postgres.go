package postgres

import "github.com/adexcell/comment-tree/pkg/postgres"

type Postgres struct {
	pgpool *postgres.Pool
}

func New(pgpool *postgres.Pool) *Postgres {
	return &Postgres{pgpool: pgpool}
}
