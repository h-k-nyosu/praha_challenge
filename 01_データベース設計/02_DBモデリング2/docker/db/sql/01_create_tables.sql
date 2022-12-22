CREATE DATABASE IF NOT EXISTS slack;

USE slack;

CREATE TABLE IF NOT EXISTS users (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "ユーザーID",
    `mail` VARCHAR(100) NOT NULL UNIQUE COMMENT "メールアドレス",
    `registered_at` DATETIME DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS workspace_statuses (
    `id` INT NOT NULL PRIMARY KEY COMMENT "ワークスペースステータスID",
    `workspace_status` VARCHAR(20) COMMENT "ワークスペースステータス"
);

CREATE TABLE IF NOT EXISTS workspaces (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "ワークスペースID",
    `domain_name` VARCHAR(100) UNIQUE NOT NULL COMMENT "ドメイン名",
    `workspace_name` VARCHAR(100) NOT NULL COMMENT "ワーククペース名",
    `workspace_status_id` INT NOT NULL DEFAULT 1 COMMENT "ワークスペースステータスID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "ワーススペース作成者",
    `created_at` DATETIME DEFAULT current_timestamp COMMENT "作成日時",
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`workspace_status_id`) REFERENCES workspace_statuses (`id`)
);

CREATE TABLE IF NOT EXISTS workspace_join_statuses (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "ワークスペース参加ユーザーステータスID",
    `workspace_join_status` VARCHAR(100) NOT NULL COMMENT "ワークスペース参加ステータス"
);

CREATE TABLE IF NOT EXISTS users_workspaces (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "ワークスペース参加ユーザーID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "会員ID",
    `workspace_id` BIGINT UNSIGNED NOT NULL COMMENT "ワークスペースID",
    `workspace_join_status_id` INT NOT NULL DEFAULT 1 COMMENT "チャンネル参加ステータスID",
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`workspace_id`) REFERENCES workspaces (`id`),
    FOREIGN KEY (`workspace_join_status_id`) REFERENCES workspace_join_statuses (`id`)
);


CREATE TABLE IF NOT EXISTS channel_statuses (
    `id` INT NOT NULL PRIMARY KEY COMMENT "チャンネルステータスID",
    `channel_status` VARCHAR(20) COMMENT "チャンネルステータス"
);

CREATE TABLE IF NOT EXISTS channels (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "チャンネルID",
    `workspace_id` BIGINT UNSIGNED NOT NULL COMMENT "ワークスペースID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "ワーススペース作成者",
    `channel_name` VARCHAR(100) NOT NULL COMMENT "チャンネル名",
    `channel_status_id` INT NOT NULL DEFAULT 1 COMMENT "チャンネルステータスID",
    FOREIGN KEY (`workspace_id`) REFERENCES workspaces (`id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`channel_status_id`) REFERENCES channel_statuses (`id`)
);

CREATE TABLE IF NOT EXISTS channel_join_statuses (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "チャンネル参加ユーザーステータス",
    `channel_join_status` VARCHAR(100) NOT NULL COMMENT "チャンネル参加ステータス"
);

CREATE TABLE IF NOT EXISTS users_channels (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "チャンネル参加ユーザーID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "会員ID",
    `channel_id` BIGINT UNSIGNED NOT NULL COMMENT "チャンネルID",
    `channel_join_status_id` INT NOT NULL DEFAULT 1 COMMENT "チャンネル参加ステータスID",
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES channels (`id`),
    FOREIGN KEY (`channel_join_status_id`) REFERENCES channel_join_statuses (`id`)
);

CREATE TABLE IF NOT EXISTS message_statuses (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "メッセージステータスID",
    `message_status` VARCHAR(100) NOT NULL COMMENT "メッセージステータス"
);

CREATE TABLE IF NOT EXISTS messages (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "メッセージID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "会員ID",
    `channel_id` BIGINT UNSIGNED NOT NULL COMMENT "チャンネルID",
    `message_status_id` INT NOT NULL COMMENT "メッセージステータスID",
    `content` TEXT NOT NULL COMMENT "メッセージ内容",
    `sent_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    `edited_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    `deleted_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES channels (`id`),
    FOREIGN KEY (`message_status_id`) REFERENCES message_statuses (`id`)
);

CREATE TABLE IF NOT EXISTS thread_message_statuses (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "メッセージステータスID",
    `thread_message_status` VARCHAR(100) NOT NULL COMMENT "メッセージステータス"
);

CREATE TABLE IF NOT EXISTS thread_messages (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "メッセージID",
    `message_id` BIGINT UNSIGNED NOT NULL COMMENT "メッセージID",
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT "会員ID",
    `channel_id` BIGINT UNSIGNED NOT NULL COMMENT "チャンネルID",
    `thread_message_status_id` INT NOT NULL COMMENT "メッセージステータスID",
    `content` TEXT NOT NULL COMMENT "メッセージ内容",
    `sent_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    `edited_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    `deleted_at` DATETIME DEFAULT '1900-01-01 00:00:00',
    FOREIGN KEY (`message_id`) REFERENCES messages (`id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES channels (`id`),
    FOREIGN KEY (`thread_message_status_id`) REFERENCES thread_message_statuses (`id`)
);