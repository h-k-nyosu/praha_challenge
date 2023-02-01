CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS articles (
    id UUID PRIMARY KEY,
    created_at timestamp not null default current_timestamp,
    created_by UUID REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS article_revisions (
    id serial PRIMARY KEY,
    article_id UUID REFERENCES articles(id),
    title VARCHAR(256) NOT NULL DEFAULT 'タイトルなし',
    content TEXT NOT NULL DEFAULT '',
    edited_at timestamp not null default current_timestamp,
    edited_by UUID REFERENCES users(id)
);