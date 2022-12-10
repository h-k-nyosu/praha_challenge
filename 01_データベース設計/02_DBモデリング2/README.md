## 回答1
次のようなスキーマを考えました。


イミュータブルデータモデリングの概念を少し取り入れたバージョン

```mermaid
erDiagram

messages ||--o{ thread_messages: ""
messages ||--|{ message_activities: ""

message_activities }o--|| message_acitivity_types: ""
message_activities ||--|o message_send_schedules: ""
message_activities ||--|o message_send_events: ""
message_activities ||--o{ message_edit_events: ""
message_activities ||--|o message_delete_events: ""

users ||--o{ workspaces: ""
users ||--o{ channels: ""
users ||--|| user_details: ""
users ||--o{ messages: ""
users ||--o{ thread_messages: ""
users ||--o{ users_workspaces: ""
users ||--o{ users_channels: ""

user_details ||--|{ history_user_details: ""

workspaces ||--o{ users_workspaces: ""
workspaces ||--o{ channels: ""
workspaces ||--o{ users: ""

users_workspaces }o--|| workspace_join_statuses: ""

channels ||--o{ users_channels: ""
channels ||--o{ channel_types: ""
channels ||--o{ users_channels: ""
channels ||--o{ messages: ""

users_channels ||--|{ history_users_channels: ""
users_channels }o--|| channel_join_statuses: ""

channels {
    ULID id PK "チャンネルID"
    ULID workspace_id FK "ワークスペースID"
    ULID user_id FK "ユーザーID"
    VARCHAR channel_type FK "チャンネルタイプ"
    VARCHAR channel_name "チャンネル名"
    DATETIME created_at "チャンネル作成日"
}

users_channels {
    ULID user_id PK "ユーザーID"
    ULID channel_id PK "チャンネルID"
    VARCHAR channel_join_status FK "チャンネル参加ステータス"
    DATETIME joined_at "参加日時"
}

history_users_channels {
    ULID id PK "ユーザーチャンネル参加履歴ID"
    ULID user_id FK "ユーザーID"
    ULID channel_id FK "チャンネルID"
    VARCHAR channel_join_status FK "チャンネル参加ステータス"
    DATETIME joined_at "参加日時"
}

messages {
    ULID id PK "メッセージID"
    ULID user_id FK "ユーザーID"
    ULID channel_id FK "チャンネルID"
    VARCHAR message_status "メッセージステータス"
    TEXT content "メッセージ内容"
}

message_activities {
    ULID id PK "メッセージアクティビティID"
    VARCHAR acitivity_type FK "アクティビティタイプ"
    DATETIME created_at "アクション日時"
}

message_acitivity_types {
    VARCHAR acitivity_type PK "アクティビティタイプ"
}

message_send_schedules {
    ULID message_activity_id PK "メッセージアクティビティID"
    ULID message_id FK "メッセージID"
    DATETIME scheduled_at "送信予定日時"
}

message_send_events {
    ULID message_activity_id PK "メッセージアクティビティID"
    ULID message_id FK "メッセージID"
    DATETIME sent_at "送信日時"
}

message_edit_events {
    ULID message_activity_id PK "メッセージアクティビティID"
    ULID message_id FK "メッセージID"
    TEXT content "メッセージ内容"
    DATETIME edited_at "編集日時"
}

message_delete_events {
    ULID message_activity_id PK "メッセージアクティビティID"
    ULID message_id FK "メッセージID"
    DATETIME deleted_at "削除日時"
}

thread_messages {
    ULID id PK "スレッドメッセージID"
    ULID message_id FK "メッセージID"
    ULID user_id FK "ユーザーID"
    ULID channel_id FK "チャンネルID"
    VARCHAR message_status FK "メッセージステータスID"
    TEXT content "スレッドメッセージステータス"
}

channel_types {
    VARCHAR channel_type PK "チャンネルタイプ"
}

workspace_join_statuses {
    VARCHAR workspace_join_status PK "ワークスペース参加ステータス"
}

channel_join_statuses {
    VARCHAR channel_join_status PK "チャンネル参加ステータス"
}

users {
    ULID id PK "ユーザーID"
    DATETIME registered_at "会員登録日時"
}

user_details {
    ULID user_id PK "ユーザーID"
    VARCHAR user_name "ユーザー名"
    VARCHAR mail "メールアドレス"
    VARCHAR phone "電話番号"
}

history_user_details {
    ULID id PK "ユーザー履歴ID"
    ULID user_id FK "ユーザーID"
    VARCHAR user_name "ユーザー名"
    VARCHAR mail "メールアドレス"
    VARCHAR phone "電話番号"
    DATETIME changed_at "変更日時"
}

workspaces {
    ULID id PK "ワークスペースID"
    ULID user_id FK "ユーザーID"
    VARCHAR workspace_name "ワークスペース名"
    DATETIME created_at "作成日時"
}

users_workspaces {
    ULID user_id PK "ユーザーID"
    ULID workspace_id PK "ワークスペースID"
    VARCHAR workspace_join_status FK "ワークスペース参加ステータス"
    DATETIME joined_at "参加日時"
}


```