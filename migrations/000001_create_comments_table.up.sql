CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT get_random_uuid(),
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    author VARCHAR(100) NOT NULL DEFAULT 'anonim',
    content TEXT NOT NULL,
    -- vectors for full-vector search
    content_tsv TSVECTOR GENERATED ALWAYS AS (to_tsvector('russian', content)) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
