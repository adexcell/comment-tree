package comment

import (
	"github.com/adexcell/comment-tree/internal/controllers"
	"github.com/wb-go/wbf/ginext"
)

const (
	comments = "/comments"
)

type handler struct {
}

func New() controllers.Handler {
	return &handler{}
}

func (h *handler) Register(router *ginext.Engine) {
	router.POST(comments, h.PostComments)
	router.GET(comments+"?parent=:id", h.GetComments)
	router.DELETE(comments+":id", h.DeleteComments)
}

func (h *handler) PostComments(c *ginext.Context) {

}

func (h *handler) GetComments(c *ginext.Context) {

}

func (h *handler) DeleteComments(c *ginext.Context) {

}
