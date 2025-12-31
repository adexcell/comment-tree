package main

import (
	"github.com/adexcell/comment-tree/internal/comment"
	"github.com/wb-go/wbf/ginext"
	"github.com/wb-go/wbf/zlog"
)

func main() {
	zlog.Init()

	zlog.Logger.Info().Msg("create httprouter")
	httprouter := ginext.New("debug")

	zlog.Logger.Info().Msg("add comment routs")
	commentHandler := comment.New()
	commentHandler.Register(httprouter)

	httprouter.Run()
}
