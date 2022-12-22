-- users
INSERT INTO users (mail) VALUES ("user1@example.com");
INSERT INTO users (mail) VALUES ("user2@example.com");
INSERT INTO users (mail) VALUES ("user3@example.com");
INSERT INTO users (mail) VALUES ("user4@example.com");
INSERT INTO users (mail) VALUES ("user5@example.com");

-- workspace_statuses
INSERT INTO workspace_statuses (id, workspace_status) VALUES (1, "表示");
INSERT INTO workspace_statuses (id, workspace_status) VALUES (2, "削除済み");

-- workspaces
INSERT INTO workspaces (domain_name, workspace_name, workspace_status_id, user_id) VALUES ("workspace1", "Workspace 1", 1, 1);
INSERT INTO workspaces (domain_name, workspace_name, workspace_status_id, user_id) VALUES ("workspace2", "Workspace 2", 2, 2);
INSERT INTO workspaces (domain_name, workspace_name, workspace_status_id, user_id) VALUES ("workspace3", "Workspace 3", 1, 3);

-- workspace_join_statuses
INSERT INTO workspace_join_statuses (id, workspace_join_status) VALUES (1, "参加中");
INSERT INTO workspace_join_statuses (id, workspace_join_status) VALUES (2, "脱退済み");

-- users_workspaces
INSERT INTO users_workspaces (user_id, workspace_id, workspace_join_status_id) VALUES (1, 1, 1);
INSERT INTO users_workspaces (user_id, workspace_id, workspace_join_status_id) VALUES (2, 2, 1);
INSERT INTO users_workspaces (user_id, workspace_id, workspace_join_status_id) VALUES (3, 3, 1);
INSERT INTO users_workspaces (user_id, workspace_id, workspace_join_status_id) VALUES (4, 1, 2);
INSERT INTO users_workspaces (user_id, workspace_id, workspace_join_status_id) VALUES (5, 2, 2);

-- channel_statues
INSERT INTO channel_statuses (id, channel_status) VALUES (1, "表示");
INSERT INTO channel_statuses (id, channel_status) VALUES (2, "削除済み");

-- channels
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (1, 1, "sales", 1);
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (1, 2, "marketing", 1);
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (2, 3, "development", 1);
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (2, 4, "qa", 1);
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (3, 5, "design", 1);
INSERT INTO channels (workspace_id, user_id, channel_name, channel_status_id) VALUES (3, 2, "hr", 1);

-- channel_join_statuses
INSERT INTO channel_join_statuses (id, channel_join_status) VALUES (1, "参加中");
INSERT INTO channel_join_statuses (id, channel_join_status) VALUES (2, "脱退済み");

-- users_channels
INSERT INTO users_channels (user_id, channel_id, channel_join_status_id) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 2),
(4, 2, 1),
(5, 3, 1),
(1, 4, 1),
(2, 5, 2),
(3, 5, 1),
(4, 5, 1),
(5, 5, 1);

-- message_statuses
INSERT INTO message_statuses (id, message_status) VALUES (1, "送信済み");
INSERT INTO message_statuses (id, message_status) VALUES (2, "編集済み");
INSERT INTO message_statuses (id, message_status) VALUES (3, "削除済み");

-- messages
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (1, 1, 1, "こんにちは", NOW());
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (2, 1, 1, "今日も1日頑張りましょう！", NOW());
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (3, 2, 1, "今日も1日がんばります！", NOW());
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (4, 2, 1, "よろしくお願いします！", NOW());
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (5, 3, 1, "おはようございます！", NOW());

-- thread_message_statuses
INSERT INTO thread_message_statuses (id, thread_message_status) VALUES 
  (1, "送信済み"),
  (2, "編集済み"),
  (3, "削除済み");

-- thread_messages
INSERT INTO thread_messages (`message_id`, `user_id`, `channel_id`, `thread_message_status_id`, `content`, `sent_at`)
VALUES (1, 1, 1, 1, "こんにちは！", "2022-01-01 00:00:00");
INSERT INTO thread_messages (`message_id`, `user_id`, `channel_id`, `thread_message_status_id`, `content`, `sent_at`, `edited_at`)
VALUES (2, 2, 1, 2, "こんばんは！", "2022-01-01 00:00:00", "2022-01-01 01:00:00");
INSERT INTO thread_messages (`message_id`, `user_id`, `channel_id`, `thread_message_status_id`, `content`, `sent_at`, `deleted_at`)
VALUES (3, 3, 2, 3, "おはようございます！これは削除されたメッセージです", "2022-01-01 00:00:00", "2022-01-01 02:00:00");
INSERT INTO thread_messages (`message_id`, `user_id`, `channel_id`, `thread_message_status_id`, `content`, `sent_at`)
VALUES (3, 3, 2, 3, "おはようございます！これは編集されたメッセージです", "2022-01-01 00:00:00");