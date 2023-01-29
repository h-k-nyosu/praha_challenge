CREATE DATABASE IF NOT EXISTS docs;

USE docs;

CREATE TABLE IF NOT EXISTS users (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `registered_at` DATETIME DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS document_statuses (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `status` VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS documents (
    `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `created_by` BIGINT UNSIGNED NOT NULL,
    `status_id` INT NOT NULL DEFAULT 1,
    `depth` INT NOT NULL,
    FOREIGN KEY (`created_by`) REFERENCES users (`id`),
    FOREIGN KEY (`status_id`) REFERENCES document_statuses (`id`)
);

CREATE TABLE IF NOT EXISTS document_updaters (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `document_id` BIGINT UNSIGNED NOT NULL,
    `updated_by` BIGINT UNSIGNED NOT NULL,
    `updated_at` DATETIME DEFAULT current_timestamp,
    FOREIGN KEY (`document_id`) REFERENCES documents (`id`),
    FOREIGN KEY (`updated_by`) REFERENCES users (`id`)
);

CREATE TABLE IF NOT EXISTS document_contents (
    `document_id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    `content` TEXT,
    FOREIGN KEY (`document_id`) REFERENCES documents (`id`)
);

CREATE TABLE IF NOT EXISTS tree_paths (
    `parent_id` BIGINT UNSIGNED NOT NULL,
    `child_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`parent_id`, `child_id`),
    FOREIGN KEY (`parent_id`) REFERENCES documents (`id`),
    FOREIGN KEY (`child_id`) REFERENCES documents (`id`)
);
