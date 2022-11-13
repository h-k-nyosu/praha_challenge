CREATE DATABASE IF NOT EXISTS sushi;
USE sushi;


CREATE TABLE IF NOT EXISTS users
(
  `id`         BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "会員ID",
  `name`       VARCHAR(100) NOT NULL COMMENT "ユーザー名",
  `age`        INT NOT NULL COMMENT "年齢",
  `sex`        INT NOT NULL COMMENT "性別",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS primary_groups
(
  `id`         INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "プライマリグループID",
  `name`       VARCHAR(100) NOT NULL COMMENT "グループ名",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS secondary_groups
(
  `id`         INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "セカンダリグループID",
  `name`       VARCHAR(100) NOT NULL COMMENT "グループ名",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS rice_sizes
(
  `id`         INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "サイズID",
  `size`       VARCHAR(100) NOT NULL COMMENT "大きさ",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS items
(
  `id`         INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "商品ID",
  `name`       VARCHAR(100) NOT NULL COMMENT "商品名",
  `primary_group_id` INT NOT NULL COMMENT "プライマリグループID",
  `secondary_group_id` INT NOT NULL COMMENT "セカンダリグループID",
  `price`      INT NOT NULL COMMENT "単価",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp,
  FOREIGN KEY  (`primary_group_id`) REFERENCES primary_groups(`id`),
  FOREIGN KEY  (`secondary_group_id`) REFERENCES secondary_groups(`id`)
);

CREATE TABLE IF NOT EXISTS orders
(
  `id`         BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "注文ID",
  `user_id`    BIGINT NOT NULL COMMENT "会員ID",
  `amount`     INT NOT NULL COMMENT "合計金額",
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp,
  FOREIGN KEY  (`user_id`) REFERENCES users(`id`)
);

CREATE TABLE IF NOT EXISTS order_details
(
  `id`         BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "注文詳細ID",
  `order_id`   BIGINT NOT NULL COMMENT "注文ID",
  `item_id`    INT NOT NULL COMMENT "商品ID",
  `quantity`   INT NOT NULL COMMENT "数量",
  `has_wasabi` BOOLEAN NOT NULL DEFAULT TRUE COMMENT "わさび有り",
  `rice_size_id` INT NOT NULL COMMENT "シャリサイズID",    
  `created_at` TIMESTAMP DEFAULT current_timestamp,
  `updated_at` TIMESTAMP DEFAULT current_timestamp ON UPDATE current_timestamp,
  FOREIGN KEY  (`order_id`) REFERENCES orders(`id`),
  FOREIGN KEY  (`item_id`) REFERENCES items(`id`),
  FOREIGN KEY  (`rice_size_id`) REFERENCES rice_sizes(`id`)
);


