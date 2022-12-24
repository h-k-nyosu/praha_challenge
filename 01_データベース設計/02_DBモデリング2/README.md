### 前提
次のようなユースケースの範囲で、Slackのようなチャットアプリのテーブル設計をしていきます。

[★] は、DBとのやりとりが必要となるステップです。

**- ワークスペースを検索する**
  - [★] フリーワードでワークスペース名が検索でき、合致するものとリスト表示する
  - 検索結果のワークスペース一覧には参加ボタンがある

**- 会員登録**
  - [★] メールアドレスを入力したら、既に登録済みかを確認して認証メールが届く
  - [★] 認証メールが届いて、そのリンクを踏んだらメールアドレスでの会員登録が完了

**- ワークスペースを作成する**
  - ログアウト状態であれば、会員登録orログインを促いしてから再度表示する
  - ワークスペース情報を入力するページを表示する
  - ドメイン名（ワークスペース一意の自然キー）が重複していないか確認
  - 招待メンバーを追加する（スキップ可能）
  - [★] ワークスペースが作成される
  - 招待メンバーに認証メールを送る
  - [★] 招待メンバーが認証メールを踏むと、会員登録とワークスペース参加者に追加される

**- ワークスペースに参加する**
  - [★] ワークスペース情報が表示される
  - [★] 参加ボタンを押すと、ワークスペース参加ユーザーに追加する
  - 参加後はワークスペースのTOPページが表示される

**- ワークスペース（TOPページ）を閲覧する**
  - [★] ユーザーがワークスペース参加者であるかを照合する
  - [★] ユーザーが参加しているチャンネル一覧を取得して表示する
  - [★] 参加チャンネルの中で、選択されているチャンネルメッセージ内容を表示する

**- チャンネルを作成する**
  - チャンネル作成ボタンを押す
  - チャンネル名を入力する
  - チャンネルに招待するユーザを選択する
  - [★] チャンネルが作成される
  - [★] 招待された人がチャンネル参加ユーザーに追加される

**- チャンネルに参加する**
  - [★] ワークスペースのチャンネル一覧が表示される
  - [★] 参加ボタンを押すと、チャンネル参加ユーザーに追加される

- **チャンネルに招待する**
  - 招待するユーザーを選択する
  - [★] 招待された人がチャンネル参加ユーザーに追加される

**- メッセージを投稿する**
  - メッセージを入力して送信する
  - [★] メッセージがDBに追加される
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上に新しくメッセージが追加される

**- スレッドメッセージを投稿する**
  - メッセージのスレッドに文章を入力して送信する
  - [★] スレッドメッセージがDBに反映される
  - [★] チャンネル参加ユーザーにスレッドメッセージ更新リクエストを送る
  - チャンネル参加者であればリクエストを反映し、UI上に新しくスレッドメッセージが追加される

**- メッセージを編集する**
  - 編集後メッセージを入力して編集ボタンを押す
  - [★] メッセージのDBデータの内容を更新して、ステータスも編集済みステータスに変更する
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上のメッセージを編集する（メッセージには編集済みと表記）

**- メッセージを削除する**
  - メッセージを削除するボタンを押す
  - [★] メッセージのDBデータを削除ステータスに変更する
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上のメッセージを削除する

**- ワークスペースを脱退する**
  - ワークスペースを脱退するボタンを押す
  - [★] チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - [★] ワークスペース参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - ユーザープロフィールを見ると脱退済みと記載される

**- チャンネルを脱退する**
  - ワークスペースを脱退するボタンを押す
  - [★] チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - ユーザープロフィールをみると脱退済みと記載される

**- メッセージを検索する**
  - ワークスペース内のフリーワードで検索をする
  - [★] そのワークスペースの参加チャンネルの中で、フリーワードを含むメッセージとスレッドメッセージを取得する
  - 取得した検索合致メッセージを表示する


---

### ER図
次のようなスキーマを考えました。


<img src="./images/db_modeling2_02.svg" style="width:2000px">


---

### ユースケース毎のクエリ

```sh
cd 01_データベース設計/02_DBモデリング2

docker compose up -d
```


PHPMyAdminでクエリを叩けます。
http://localhost:8080/




**- ワークスペースを検索する**
  - [★] フリーワードでワークスペース名が検索でき、合致するものとリスト表示する
  - 検索結果のワークスペース一覧には参加ボタンがある


**フリーワードでワークスペース名が検索でき、合致するものとリスト表示する**
```sql
SELECT
    w.id as workspace_id
    ,w.workspace_name as workspace_name
    ,w.domain_name as domain_name
FROM
    workspaces as w
    LEFT JOIN workspace_statuses as ws
    ON w.workspace_status_id = ws.id
WHERE
    ws.workspace_status = "表示"
    AND w.workspace_name LIKE "%work%" -- @keyword

```

---

**- 会員登録**
  - [★] メールアドレスを入力したら、既に登録済みかを確認して認証メールが届く
  - [★] 認証メールが届いて、そのリンクを踏んだらメールアドレスでの会員登録が完了


**会員登録にあたってメールアドレスが登録済みかの確認**
```sql
SELECT
    id
FROM
    users as u
WHERE
    u.mail == "user6@example.com" -- @mail
```

**会員登録**
```sql
INSERT INTO users (mail) VALUES ("user6@example.com");
```

---

**- ワークスペースを作成する**
  - ログアウト状態であれば、会員登録orログインを促いしてから再度表示する
  - ワークスペース情報を入力するページを表示する
  - ドメイン名（ワークスペース一意の自然キー）が重複していないか確認
  - 招待メンバーを追加する（スキップ可能）
  - [★] ワークスペースが作成される
  - 招待メンバーに認証メールを送る
  - [★] 招待メンバーが認証メールを踏むと、会員登録とワークスペース参加者に追加される

**ワークスペースが作成される**
```sql
INSERT INTO workspaces
    (domain_name, workspace_name, user_id)
    VALUES ("confirm-usecases", "usecases", 6);
```


**招待メンバーが認証メールを踏むと、会員登録とワークスペース参加者に追加される**

```sql
/* 会員登録 */
INSERT INTO users (mail) VALUES ("user7@example.com");

/* 招待者が認証メールを踏むと、ワークスペース参加者に追加 */
INSERT INTO users_workspaces (user_id, workspace_id) VALUES (7, 4);
```

---

**- ワークスペースに参加する**
  - [★] ワークスペース情報が表示される
  - [★] 参加ボタンを押すと、ワークスペース参加ユーザーに追加される
  - 参加後はワークスペースのTOPページが表示される

**ワークスペース情報が表示される**

この時、表示ステータス（削除されていない）ワークスペースの情報をリストで表示する。
```sql
SELECT
    w.id as workspace_id
    ,w.workspace_name as workspace_name
    ,w.domain_name as domain_name
    ,CASE
        WHEN uw.workspace_join_status IS NULL THEN "未参加"
        WHEN uw.workspace_join_status = "脱退済み" THEN "未参加"
        ELSE "参加中"
    END as workspace_join_status
FROM
    (
        SELECT
            tmp_w.id as id
        	,tmp_w.workspace_name as workspace_name
        	,tmp_w.domain_name as domain_name
        FROM
            workspaces as tmp_w
            LEFT JOIN workspace_statuses as tmp_ws
            ON tmp_w.workspace_status_id = tmp_ws.id
        WHERE
            tmp_ws.workspace_status = "表示"
    ) as w
    LEFT JOIN 
    (
        SELECT
        	tmp_uw.workspace_id as workspace_id
        	,tmp_wjs.workspace_join_status as workspace_join_status
       	FROM
        	users_workspaces as tmp_uw
            LEFT JOIN workspace_join_statuses as tmp_wjs
            ON tmp_uw.workspace_join_status_id = tmp_wjs.id
       	WHERE
        	tmp_uw.user_id = 1
    ) as uw
    ON w.id = uw.workspace_id
```


**参加ボタンを押すと、ワークスペース参加ユーザーに追加される**
```sql
INSERT INTO users_workspaces (user_id, workspace_id) VALUES (1, 1);
```

---

**- ワークスペース（TOPページ）を閲覧する**
  - [★] ユーザーがワークスペース参加者であるかを照合する
  - [★] ユーザーが参加しているチャンネル一覧を取得して表示する
  - [★] 参加チャンネルの中で、選択されているチャンネルメッセージ内容を表示する


**ユーザーがワークスペース参加者であるかを照合する**

```sql
SELECT
    wjs.workspace_join_status
FROM
    users_workspaces as uw
    LEFT JOIN workspace_join_statuses as wjs
    ON uw.workspace_join_status_id = wjs.id
WHERE
    uw.user_id = 1           -- @user_id
    AND uw.workspace_id = 1  -- @workspace_id
```

**ユーザーが参加しているチャンネル一覧を取得して表示する**

```sql
SELECT
    uc.channel_id
    ,c.channel_name
FROM
    (
        SELECT
            tmp_uc.channel_id as channel_id
        FROM
            users_channels as tmp_uc
        WHERE
            tmp_uc.user_id = 1 -- @user_id
            AND tmp_uc.channel_join_status_id = 1
    ) as uc
    LEFT JOIN channels as c
    ON uc.channel_id = c.id
WHERE
    c.channel_status_id = 1
```

**参加チャンネルの中で、選択されているチャンネルメッセージ内容を表示する**

```sql
SELECT
    m.id as message_id
    ,m.user_id as user_id
    ,m.content as content
    ,m.sent_at as sent_at
    ,m.edited_at as edited_at
    ,m.deleted_at as deleted_at
    ,m.message_status_id as message_status_id
    ,count_tm.count_thread_messages as count_thread_messages
FROM
    (
        SELECT
            tmp_m.id as id
            ,tmp_m.user_id as user_id
            ,tmp_m.content as content
            ,tmp_m.sent_at as sent_at
            ,tmp_m.edited_at as edited_at
            ,tmp_m.deleted_at as deleted_at
            ,tmp_m.message_status_id as message_status_id
        FROM
            messages as tmp_m
        WHERE
            tmp_m.channel_id = 1 -- @channel_id
    ) as m
    LEFT JOIN
    (
        SELECT
            tm.message_id as message_id
            ,COUNT(tm.id) as count_thread_messages
        FROM
            thread_messages as tm
            LEFT JOIN thread_message_statuses as tms
            ON tm.thread_message_status_id = tms.id
        WHERE
            tm.channel_id = 1 -- @channel_id
            tms.thread_message_status in ("送信済み", "編集済み")
        GROUP BY
            tm.message_id
    ) as count_tm
    ON m.id = count_tm.message_id
ORDER BY
    m.sent_at DESC
;
```

---

**- チャンネルを作成する**
  - チャンネル作成ボタンを押す
  - チャンネル名を入力する
  - チャンネルに招待するユーザを選択する
  - [★] チャンネルが作成される
  - [★] 招待された人がチャンネル参加ユーザーに追加される

**チャンネルが作成される**
```sql
INSERT INTO channels (workspace_id, user_id, channel_name) VALUES (1, 1, "engineering");
```

**招待された人がチャンネル参加ユーザーに追加される**
```sql
INSERT INTO users_channels (user_id, channel_id)VALUES (3, 7);
```

---

**- チャンネルに参加する**
  - [★] ワークスペースのチャンネル一覧が表示される
  - [★] 参加ボタンを押すと、チャンネル参加ユーザーに追加される

**ワークスペースのチャンネル一覧が表示される**
```sql
SELECT
    c.id
    ,c.channel_name
    ,CASE
        WHEN uc.channel_join_status_id IS NULL THEN "未参加" 
        WHEN uc.channel_join_status_id = 2 THEN "未参加"
        ELSE "参加中"
    END as channel_join_status
FROM
    (
        SELECT
            tmp_c.id as id
            ,tmp_c.channel_name as channel_name
            ,tmp_c.channel_status_id as channel_status_id
        FROM
            channels as tmp_c
        WHERE
            tmp_c.workspace_id = 1 -- @workspace_id
    ) as c
    LEFT JOIN
    (
        SELECT
            tmp_uc.channel_id as channel_id
            ,tmp_uc.channel_join_status_id as channel_join_status_id
        FROM
            users_channels as tmp_uc
        WHERE
            tmp_uc.user_id = 1 -- @user_id
            AND tmp_uc.channel_join_status_id != 1
    ) as uc
    ON c.id = uc.channel_id
WHERE
    c.channel_status_id = 1
;
```

**参加ボタンを押すと、チャンネル参加ユーザーに追加される**
```sql
INSERT INTO users_channels (user_id, channel_id) VALUES (1, 7)
```

---

**- チャンネルに招待する**
  - 招待するユーザーを選択する
  - [★] 招待された人がチャンネル参加ユーザーに追加される

**招待された人がチャンネル参加ユーザーに追加される**
```sql
INSERT INTO users_channels (user_id, channel_id) VALUES (3, 7)
```

---


**- メッセージを投稿する**
  - メッセージを入力して送信する
  - [★] メッセージがDBに追加される
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上に新しくメッセージが追加される

**メッセージがDBに追加される**
```sql
INSERT INTO messages (user_id, channel_id, message_status_id, content, sent_at) VALUES (3, 1, 1, "今日の昼ごはん鹿肉食べたんですけど、めっちゃ柔らかかったです！", NOW());
```

---

**- スレッドメッセージを投稿する**
  - メッセージのスレッドに文章を入力して送信する
  - [★] スレッドメッセージがDBに反映される
  - チャンネル参加ユーザーにスレッドメッセージ更新リクエストを送る
  - チャンネル参加者であればリクエストを反映し、UI上に新しくスレッドメッセージが追加される

**スレッドメッセージがDBに反映される**
```sql
INSERT INTO thread_messages (`message_id`, `user_id`, `channel_id`, `message_status_id`, `content`, `sent_at`)
VALUES (5, 1, 1, 1, "鹿肉いいですね！私はまだ食べたことないです！", NOW());
```

---

**- メッセージを編集する**
  - 編集後メッセージを入力して編集ボタンを押す
  - [★] メッセージのDBデータの内容を更新して、ステータスも編集済みステータスに変更する
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上のメッセージを編集する（メッセージには編集済みと表記）

**メッセージのDBデータの内容を更新して、ステータスも編集済みステータスに変更する**
```sql
UPDATE messages
SET
    message_status_id = 2,
    content = "あ、やっぱり鹿肉食べたことありましたわ！"
WHERE id = 7 -- @message_id
;
```

---

**- メッセージを削除する**
  - メッセージを削除するボタンを押す
  - [★] メッセージのDBデータを削除ステータスに変更する
  - チャンネル参加ユーザーにメッセージ更新リクエストを送る(更新分をクライアントへ送信する)
  - チャンネル参加者であればリクエストを反映し、UI上のメッセージを削除する

**メッセージのDBデータを削除ステータスに変更する**
```sql
UPDATE messages
SET message_status_id = 3
WHERE id = 7 -- @message_id
;
```

---


- **ワークスペースを脱退する**
  - ワークスペースを脱退するボタンを押す
  - [★] チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - [★] ワークスペース参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - ユーザープロフィールを見ると脱退済みと記載される

**チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する**
```sql
/* 脱退するワークスペースで参加しているチャンネルを取得する */
SELECT
    uc.channel_id
FROM
    users_channels as uc
    LEFT JOIN channels as c
    ON uc.channel_id = c.id
WHERE
    uc.user_id = 1 -- @user_id
    AND c.workspace_id = 1 -- @workspace_id
    AND uc.channel_join_status_id = 1;
;

/* チャンネルを脱退する */
UPDATE users_channels
SET channel_join_status_id in (1) -- @channel_id
WHERE user_id = 1 AND channel_id = 7;
```

**ワークスペース参加者リストの該当ユーザーのステータスを脱退済みに変更する**
```sql
UPDATE users_workspaces
SET workspace_join_status_id = 2
WHERE
    user_id = 1 -- @user_id
    AND workspace_id = 1 -- @workspace_id
;
```

---

**- チャンネルを脱退する**
  - ワークスペースを脱退するボタンを押す
  - [★] チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する
  - ユーザープロフィールをみると脱退済みと記載される

**チャンネル参加者リストの該当ユーザーのステータスを脱退済みに変更する**
```sql
UPDATE users_channels
SET channel_join_status_id = 2
WHERE user_id = 1 AND channel_id = 7;
```

---

**- メッセージを検索する**
  - ワークスペース内のフリーワードで検索をする
  - [★] そのワークスペースの参加チャンネルの中で、フリーワードを含むメッセージとスレッドメッセージを取得する
  - 取得した検索合致メッセージを表示する

**そのワークスペースの参加チャンネルの中で、フリーワードを含むメッセージとスレッドメッセージを取得する**
```sql
SELECT
    result.id as id
    ,c.channel_name as channel_name
    ,result.user_id as user_id
    ,result.content as content
    ,result.sent_at as sent_at
FROM
    (
        SELECT
        	m.channel_id as channel_id
            ,m.id as id
            ,m.user_id as user_id
            ,content as content
            ,m.sent_at as sent_at
        FROM
            messages as m
        WHERE
        	m.message_status_id = 1
            AND content LIKE '%！%' -- @keyword
        UNION
        SELECT
        	tm.channel_id as channel_id
            ,CONCAT(tm.channel_id, "/", tm.id) as id
            ,tm.user_id as user_id
            ,tm.content as content
            ,tm.sent_at as sent_at
        FROM
            thread_messages as tm
        WHERE
        	tm.thread_message_status_id = 1
            AND tm.content LIKE '%！%' -- @keyword
    ) as result
    INNER JOIN
        (
            SELECT
                tmp_uc.channel_id as channel_id
                ,tmp_uc.channel_join_status_id as channel_join_status_id
            FROM
                users_channels as tmp_uc
            WHERE
                tmp_uc.user_id = 1  -- @user_id
                AND tmp_uc.channel_join_status_id = 1
         ) as uc
    ON result.channel_id = uc.channel_id
    LEFT JOIN channels as c
    ON uc.channel_id = c.id
ORDER BY
    result.sent_at DESC
;
```


---

### おまけ

イミュータブルデータモデルに則って作成したER図

<img src="./images/db_modeling2_01_imutable.svg" style="width:2000px">