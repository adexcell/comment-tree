package domain

import (
	"errors"
	"time"
)

var (
	ErrCommentNotFound = errors.New("comment not found")
	ErrContentTooLong  = errors.New("comment exceeds 10_000 characters")
	ErrContentEmpty    = errors.New("comment cannot be empty")
	ErrEmptyAuthor     = errors.New("author name cannot be empty")
)

type Comment struct {
	ID         int64      `json:"id"`
	ContentID  int64      `json:"content_id"`
	ParentID   *int64     `json:"parent_id"`
	Path       []int64    `json:"path"`
	AuthorID   int64      `json:"auth_id"`
	AuthorName string     `json:"author_name"`
	Content    string     `json:"content"`
	CreatedAt  time.Time  `json:"created_at"`
	UpdateAt   time.Time  `json:"updated_at"`
	DeletedAt  *time.Time `json:"deleted_at,omitempty"`
}

func (c *Comment) IsRoot() bool {
	return c.ParentID == nil
}

func (c *Comment) Depth() int {
	if len(c.Path) == 0 {
		return 0
	}
	return len(c.Path) - 1
}

func (c *Comment) Validate() error {
	if len(c.Content) == 0 {
		return ErrContentEmpty
	}

	if len(c.Content) > 10_000 {
		return ErrContentTooLong
	}

	if c.AuthorName == "" {
		return ErrEmptyAuthor
	}

	return nil
}

type CreateCommentRequest struct {
	ContentID  int64  `json:"content_id" binding:"required"`
	ParentID   *int64 `json:"parent_id" binding:"required"`
	AuthorID   int64  `json:"author_id" binding:"required"`
	AuthorName string `json:"author_name" binding:"required"`
	Content    string `json:"content" binding:"required"`
}

type GetTreeRequest struct {
	ContentID int64  `form:"content_id" binding:"required"`
	ParentID  *int64 `form:"parent_id"`
	Limit     int    `form:"limit" binding:"min=1,max=100"`
	Offset    int    `form:"offset" binding:"min=0"`
}

type SearchRequest struct {
	ContentID int64 `form:"content_id" binding:"required"`
	Query     string `form:"q" binding:"required,min=3"`
	Limit     int `form:"limit" binding:"min=1,max=50"`
}
