-- Откат миграции
DROP TRIGGER IF EXISTS trg_comment_updated_at ON comments;
DROP TRIGGER IF EXISTS trg_comment_path ON comments;
DROP FUNCTION IF EXISTS update_updated_at();
DROP FUNCTION IF EXISTS update_comment_path();
DROP TABLE IF EXISTS comments CASCADE;
