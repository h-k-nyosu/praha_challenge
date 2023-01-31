CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slack_member_id VARCHAR(12) NOT NULL
);

CREATE TABLE IF NOT EXISTS task_statuses (
    id INTEGER PRIMARY KEY,
    status VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    remind_time timestamp NOT NULL,
    remind_interval INTERVAL NOT NULL,
    status_id INTEGER REFERENCES task_statuses(id) DEFAULT 1
);


CREATE TABLE IF NOT EXISTS reminder_recipients (
    id SERIAL PRIMARY KEY,
    task_id UUID REFERENCES tasks(id),
    user_id UUID REFERENCES users(id)
);
