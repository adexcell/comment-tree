-- Создание таблицы комментариев
CREATE TABLE IF NOT EXISTS comments (
    id BIGSERIAL PRIMARY KEY,
    content_id BIGINT NOT NULL,
    parent_id BIGINT,
    path INTEGER[] NOT NULL DEFAULT '{}',
    author_id BIGINT NOT NULL,
    author_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL CHECK (length(content) > 0 AND length(content) <= 10000),
    content_tsv TSVECTOR GENERATED ALWAYS AS 
        (to_tsvector('russian', content)) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) 
        REFERENCES comments(id) ON DELETE CASCADE
);

-- Индексы для performance
CREATE INDEX idx_comments_content_id_path 
    ON comments(content_id, path) 
    WHERE deleted_at IS NULL;

CREATE INDEX idx_comments_path_gin 
    ON comments USING GIN(path);

CREATE INDEX idx_comments_parent_id 
    ON comments(parent_id) 
    WHERE deleted_at IS NULL;

CREATE INDEX idx_comments_content_tsv 
    ON comments USING GIN(content_tsv);

-- Trigger для автоматического заполнения path
CREATE OR REPLACE FUNCTION update_comment_path()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.parent_id IS NULL THEN
        NEW.path := ARRAY[NEW.id];
    ELSE
        SELECT path || NEW.id INTO NEW.path
        FROM comments
        WHERE id = NEW.parent_id;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Parent comment % does not exist', NEW.parent_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_comment_path
BEFORE INSERT ON comments
FOR EACH ROW
EXECUTE FUNCTION update_comment_path();

-- Trigger для updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_comment_updated_at
BEFORE UPDATE ON comments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();