# 課題1

## ER図

<img src="./images/DBモデリング4.drawio.svg">


## タスクの作成

```sql
INSERT INTO tasks (id, content, created_by, remind_time, remind_interval)
VALUES ('efdf1512-9ab3-4932-9b36-23d63e695e64', '日報の記載をお願いします！', 'fa5c7639-ce06-6dc2-a662-072b87181e45', now() + cast('1 day' as INTERVAL), '1 day');

INSERT INTO reminder_recipients (user_id, task_id) VALUES
('31b5d740-5fb0-f072-2cd8-a3edcd1301a7', 'efdf1512-9ab3-4932-9b36-23d63e695e64'),
('5672016b-d8b1-1dc1-35c6-a7fa53e8da40', 'efdf1512-9ab3-4932-9b36-23d63e695e64');
```


## タスク完了

```sql
UPDATE tasks SET status_id = 2 WHERE id = '4dfde1dc-e4fd-4857-92fc-03ee58d4e067';
```

## 自分が担当する未完了タスクの一覧表示

```sql
SELECT
    T3.slack_member_id as mention
    ,T2.content as task_content
    ,T2.remind_time as remind_time
    ,T2.remind_interval as remind_interval
FROM
    (
        SELECT
            *
        FROM
            reminder_recipients
        WHERE
            user_id = 'bf948a6f-a8f0-fc9d-cc5a-975950359661'
    ) as T1
    INNER JOIN
    (
        SELECT
            *
        FROM
            tasks
        WHERE
            status_id = 1
     ) as T2
    ON T1.task_id = T2.id
    LEFT JOIN users as T3
    ON T1.user_id = T3.id
;
```

## 配信が必要なリマインダーの抽出とリマインド時間の更新

```sql
SELECT
    u.slack_member_id as mention
    ,t.content as task_content
FROM
    (
        SELECT
            *
        FROM
            tasks
        WHERE
            remind_time <= now()
            AND status_id = 1
    ) as t
    LEFT JOIN reminder_recipients as rr
    ON rr.task_id = t.id
    LEFT JOIN users as u
    ON rr.user_id = u.id
;

UPDATE tasks
SET remind_time = remind_time + remind_interval
WHERE remind_time <= now() AND status_id = 1

```




