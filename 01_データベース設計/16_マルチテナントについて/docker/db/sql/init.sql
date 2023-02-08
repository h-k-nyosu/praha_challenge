-- 例示のためのデータ準備
CREATE TABLE users (
    id         SERIAL,
    name       TEXT NOT NULL,
    email      TEXT,
    company_id TEXT NOT NULL,
    PRIMARY KEY (company_id, id)
);

INSERT INTO users VALUES (1, 'yamada', 'yamada@001.example.com', '001');
INSERT INTO users VALUES (2, 'murata', 'murata@001.example.com', '001');
INSERT INTO users VALUES (1, 'tanaka', 'tanaka@002.example.com', '002');

-- ロールおよびユーザーの作成と権限の許可
CREATE ROLE sales_company;
GRANT SELECT,INSERT,UPDATE,DELETE ON users TO sales_company;

CREATE USER sales_company_001 WITH PASSWORD 'pass';
CREATE USER sales_company_002 WITH PASSWORD 'pass';
GRANT sales_company TO sales_company_001;
GRANT sales_company TO sales_company_002;

CREATE USER presiding_company WITH PASSWORD 'pass';
GRANT SELECT,INSERT,UPDATE,DELETE ON users TO presiding_company;

-- RLS の有効化とポリシーの作成
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_for_sales_company ON users TO sales_company
    USING (CONCAT('sales_company_', company_id) = CURRENT_USER);
CREATE POLICY users_for_presiding_company ON users TO presiding_company
    USING (true) WITH CHECK (true);