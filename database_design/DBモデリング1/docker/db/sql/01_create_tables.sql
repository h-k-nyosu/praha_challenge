CREATE DATABASE IF NOT EXISTS sushi;

USE sushi;

CREATE TABLE IF NOT EXISTS users (
    `user_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "会員ID",
    `user_name` VARCHAR(100) NOT NULL COMMENT "ユーザー名",
    `number` VARCHAR(32) NOT NULL COMMENT "電話番号",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS coupons (
    `coupon_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "クーポンID",
    `discount` INT NOT NULL COMMENT "割引金額",
    `validate_start_date` DATETIME NOT NULL COMMENT "有効期限開始日",
    `validate_end_date` DATETIME NOT NULL COMMENT "有効期限終了日",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS users_coupons (
    `user_coupon_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "所持クーポンID",
    `user_id` BIGINT NOT NULL COMMENT "会員ID",
    `coupon_id` BIGINT NOT NULL COMMENT "クーポンID",
    `is_used` BOOLEAN NOT NULL DEFAULT FALSE COMMENT "使用済みフラグ",
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT "削除フラグ",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`coupon_id`) REFERENCES coupons (`coupon_id`)
);

CREATE TABLE IF NOT EXISTS item_category_types (
    `category_type_id` INT NOT NULL PRIMARY KEY COMMENT "商品カテゴリタイプID",
    `category_type_name` VARCHAR(100) NOT NULL COMMENT "カテゴリタイプ名",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS item_categories (
    `category_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "商品カテゴリID",
    `category_type_id` INT NOT NULL COMMENT "商品カテゴリタイプID",
    `category_name` VARCHAR(100) NOT NULL COMMENT "タイプ名",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`category_type_id`) REFERENCES item_category_types (`category_type_id`)
);

CREATE TABLE IF NOT EXISTS rice_sizes (
    `rice_size_id` INT NOT NULL PRIMARY KEY COMMENT "サイズID",
    `size` VARCHAR(100) NOT NULL COMMENT "大きさ",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS order_statuses (
    `order_status_id` INT NOT NULL PRIMARY KEY COMMENT "注文ステータスID",
    `order_status_name` VARCHAR(100) NOT NULL COMMENT "カテゴリ名",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS wasabi_options (
    `wasabi_option_id` INT NOT NULL PRIMARY KEY COMMENT "わさびオプションID",
    `wasabi_option_name` VARCHAR(100) NOT NULL COMMENT "わさび選択肢",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
);

CREATE TABLE IF NOT EXISTS items (
    `item_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "商品ID",
    `item_name` VARCHAR(100) NOT NULL COMMENT "商品名",
    `category_id` INT NOT NULL COMMENT "商品カテゴリID",
    `price` INT NOT NULL COMMENT "単価",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`category_id`) REFERENCES item_categories (`category_id`)
);

CREATE TABLE IF NOT EXISTS orders (
    `order_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "注文ID",
    `user_id` BIGINT COMMENT "会員ID",
    `order_status_id` INT NOT NULL COMMENT "支払いステータスID",
    `total_quantity` INT NOT NULL COMMENT "合計皿数",
    `ordered_at` DATETIME NOT NULL COMMENT "注文日時",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`order_status_id`) REFERENCES order_statuses (`order_status_id`)
);

CREATE TABLE IF NOT EXISTS order_details (
    `order_detail_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "注文詳細ID",
    `order_id` BIGINT NOT NULL COMMENT "注文ID",
    `item_id` INT NOT NULL COMMENT "商品ID",
    `quantity` INT NOT NULL COMMENT "数量",
    `subtotal` INT NOT NULL COMMENT "価格",
    `wasabi_option_id` INT NOT NULL DEFAULT 1 COMMENT "わさびオプション",
    `rice_size_id` INT NOT NULL COMMENT "シャリサイズID",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`order_id`) REFERENCES orders (`order_id`),
    FOREIGN KEY (`item_id`) REFERENCES items (`item_id`),
    FOREIGN KEY (`wasabi_option_id`) REFERENCES wasabi_options (`wasabi_option_id`),
    FOREIGN KEY (`rice_size_id`) REFERENCES rice_sizes (`rice_size_id`)
);

CREATE TABLE IF NOT EXISTS purchases (
    `purchase_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "購入ID",
    `user_id` BIGINT COMMENT "会員ID",
    `user_coupon_id` BIGINT COMMENT "所持クーポンID",
    `total` INT NOT NULL COMMENT "合計金額",
    `purchased_at` DATETIME NOT NULL COMMENT "購入日時",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`user_coupon_id`) REFERENCES users_coupons (`user_coupon_id`)
);

CREATE TABLE IF NOT EXISTS purchase_reservations (
    `purchase_reservation_id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT "購入予約ID",
    `order_id` BIGINT NOT NULL COMMENT "注文ID",
    `purchase_reservation_at` DATETIME NOT NULL COMMENT "購入予約日時",
    `created_at` DATETIME DEFAULT current_timestamp,
    `updated_at` DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    FOREIGN KEY (`order_id`) REFERENCES orders (`order_id`)
);