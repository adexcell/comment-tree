CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_comments_tsv ON comments USING GIN (content_tsv);
CREATE INDEX IF NOT EXISTS idx_comments_created ON comments(created_at DESC);
