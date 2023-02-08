SmartHRやfreeeなど、1つのサービスを異なる企業がお互いに干渉しないように使うサービスは増えています。仮に自分の実装ミスでトヨタ自動車の会計データが本田技研に表示されてしまったら、とんでもない賠償金を請求されて10代先まで借金が残ってしまいそうですよね。



複数のユーザーが住み分けながら1つのサービスを使う「マルチテナントアーキテクチャ」はSaaSの基本的な形ですから、しっかり学んでおきましょう



# 課題1

「妥当SmartHR!」を旗印に生まれたスタートアップ「IntelligentHR」のエンジニアであるあなたは、テナント（企業など）毎のデータを取得する際は以下のようなクエリを発行するようなアプリケーションを作成しました


select * from Data where tenant_id = 'praha';


「パクリすぎじゃない？」という市場の声を押しのけて資金調達に成功したIntelligentHRは採用を強化し、新たに3名の新人エンジニアが入社しました。しかし開発現場は大忙し。コードレビューもロクにできず、新人の1人が新機能を開発する際、うっかりとテナントを指定し忘れて、こんなクエリを発行するコードを本番環境にデプロイしてしまいました


select * from Employees; <- where tenant_id = 'praha'を指定し忘れている！


ある日、株式会社HogeHogeの社長がIntelligentHRを使っていると、そのサービスに登録しているすべての会社の全従業員データが表示されていることに気づき、大変な騒ぎになりました。結果IntelligentHRは多額の賠償金を請求されて事業停止に追い込まれてしまいました...


タイムマシンを使って過去に戻れるとしたら、このようなミスが起きないよう、どんな対策を施しますか？

対策として、
 - マルチテナントパターンを採用し、企業（テナント）毎にアクセスできるデータを制限することで、情報漏洩リスクを軽減する
   - データベースサーバ自体を分けてサイロモデルにする
   - 同一データベース内に、別スキーマとしてテナント毎に分けることで分離する（スキーマ分離のブリッジモデル）
   - 同一データベース・スキーマ内に、別テーブルとしてテナント毎に分けることで分離する（テーブル分離のブリッジモデル）
   - 同一データベース・スキーマ・テーブル内に、データを格納し、行レベルのアクセス制御を行う（プールモデル）


# 課題2

マルチテナントアーキテクチャには「テナント毎にデータベースを分割する」「テナント毎にスキーマを分割する」「すべてのテナントで同じスキーマを使う」など様々なパターンがあります。それぞれのメリット・デメリットを調べてみましょう
コスパ的に現実的なのは全てのテナントを同じスキーマで扱うパターンではないかと私（課題製作者）は個人的に考えています。その場合、（課題1ですでに調べられた方もいらっしゃるかもしれませんが）PostgreSQLが提供するRLS（Row-Level Security）が非常に有力な組み合わせです。RLSと、これを活用したマルチテナントアーキテクチャの実装方法について調べてみましょう

## データベースサーバ自体を分けてサイロモデルにする

### メリット
 - あるテナントのアクティビティが他のテナントに影響を与えない
 - テナント固有にスケーリングアップが可能
 - 可用性をテナントレベルで管理が可能
 - データベース障害時の影響を抑えられる
 - 既存構成からの移行が可能


### デメリット
 - テナント数が多くなるほど、メンテナンス効率が悪くなる
 - コストが高くなる傾向にある



## 同一データベース内に、別スキーマとしてテナント毎に分けることで分離する（スキーマ分離のブリッジモデル）

### メリット

 - サイロモデルと比較して新規テナントの作成が容易
 - CPU、メモリ、ディスクの管理がシンプル
 - 既存のシングルテナントソリューションからの移行が比較的容易
 - サイロモデルに比べてコストを抑えられる


### デメリット

 - テナント数に比例してテーブル数が増加することで、パフォーマンスが極端に低下する可能性がある（テーブルを開いている数が増えるとキャッシュ上限に達し、パフォーマンス低下につながる可能性がある）
 - 他テナント・ワークロードによるリソース占有によるパフォーマンス低下を及ぼすリスク（ノイジーネイバー）
 - 障害が発生した際、同一データベースのため全テナントが停止となる



## 同一データベース・スキーマ内に、別テーブルとしてテナント毎に分けることで分離する（テーブル分離のブリッジモデル）

### メリット

 - スキーマ分離のブリッジモデルと同様


### デメリット

 - スキーマ分離のブリッジモデルと同様。加えて以下が追加される
 - テナント毎にテーブル名を変更する必要があるなど、テーブル管理が煩雑となる
 - 既存のアプリケーションからの移行の場合、アプリケーションの改修が必要



## 同一データベース・スキーマ・テーブル内に、データを格納し、行レベルのアクセス制御を行う（プールモデル）

### メリット

 - テーブル構成変更や機能拡張などのメンテナンスが容易（改修箇所が単体で済むため）
 - 複数データベース・スキーマといったデータの冗長性が削減される
 - 新規テナントの作成は新規テナントIDの作成のみでOK
 - テナント毎のポリシー管理が不要
 - CPU、メモリ、ディスクの管理がシンプル
 - サイロモデルに比べてコストを抑えられる

### デメリット
 - 既存アプリケーションの改修が必要
 - 別テナントの情報が表示されてしまうリスクがある
 - ノイジーネイバーによるパフォーマンスの影響
 - 障害発生時に全テナントが停止



### RLSでの実装

PostgreSQLでテナント毎のアクセス制御を実装した。


```sql
-- 例示のためのデータ準備
CREATE TABLE users (
    id         INT  NOT NULL,
    name       TEXT NOT NULL,
    email      TEXT,
    company_id TEXT NOT NULL,
    PRIMARY KEY (company_id, id)
);

INSERT INTO users VALUES (1, 'yamada', 'yamada@001.example.com', '001');
INSERT INTO users VALUES (2, 'murata', 'murata@001.example.com', '001');
INSERT INTO users VALUES (1, 'tanaka', 'tanaka@002.example.com', '002');
```

 - company_id（001, 002）の2種類を作成して、RLSが実現できているかを検証する。

 - このcompany_idは、DB接続に利用するユーザー名の末尾番号と一致する形式を取る。


<br>

```sql

-- ロールおよびユーザーの作成と権限の許可
CREATE ROLE sales_company;
GRANT SELECT,INSERT,UPDATE,DELETE ON users TO sales_company;

CREATE USER sales_company_001 WITH PASSWORD 'pass';
CREATE USER sales_company_002 WITH PASSWORD 'pass';
GRANT sales_company TO sales_company_001;
GRANT sales_company TO sales_company_002;

CREATE USER presiding_company WITH PASSWORD 'pass';
GRANT SELECT,INSERT,UPDATE,DELETE ON users TO presiding_company;

```

 - sales_companyロールと、sales_company_001,sales_company_002、presidingi_companyユーザーを作成
 - sales_company_00XにGRANT文でsales_companyロールを付与
 - presiding_companyにはusersテーブルに対して、CRUD処理ができる権限を付与

<br>


```sql

-- RLS の有効化とポリシーの作成
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_for_sales_company ON users TO sales_company
    USING (CONCAT('sales_company_', company_id) = CURRENT_USER);
CREATE POLICY users_for_presiding_company ON users TO presiding_company
    USING (true) WITH CHECK (true);

```

 - usersテーブルにROW LEBEL SECURITY(RLS)の有効化
 - usersテーブルに関するusers_for_sales_companyポリシーを作成し、sales_companyロールにアタッチ。ポリシー条件としてユーザー名と加工したusers.company_idの一致を見る
 - usersテーブルに関するusers_for_presiding_companyポリシーを作成し、presiding_companyロールにアタッチ。ポリシー条件は全てtrueとする（閲覧可能ユーザー）

[init.sql](./docker/db/sql/init.sql)

[参考記事](https://labs.septeni.co.jp/entry/2022/03/28/193223)


### パフォーマンスについて

RLS有効化に伴うパフォーマンスについても検証してみる。

```sql

/* 1051201件のデータをINSERT */
INSERT INTO users(
	name,
	email,
	company_id
)
SELECT 
    SUBSTRING(md5(clock_timestamp()::text), 1, 5)::varchar,
    SUBSTRING(md5(clock_timestamp()::text), 1, 5)::varchar || '@example.com',
    LPAD(CEIL(RANDOM() * 100)::varchar, 3, '0')
FROM
    generate_series(
        '2020-01-01',
        '2021-12-31', INTERVAL '1 minute'
    ) AS s;

```


EXPLAIN ANALYSISを使ってパフォーマンスを検証する。


```sql
SET ROLE sales_company_001;

explain analyze select COUNT(*) from users;

/** Result
Finalize Aggregate  (cost=16400.72..16400.73 rows=1 width=8) (actual time=182.044..185.498 rows=1 loops=1)
  ->  Gather  (cost=16400.50..16400.71 rows=2 width=8) (actual time=181.809..185.460 rows=3 loops=1)
        Workers Planned:2
        Workers Launched:2
        ->  Partial Aggregate  (cost=15400.50..15400.51 rows=1 width=8) (actual time=170.874..170.875 rows=1 loops=3)
              ->  Parallel Seq Scan on users  (cost=0.00..15395.03 rows=2190 width=0) (actual time=0.088..170.459 rows=3508 loops=3)
                    Filter: (concat('sales_company_', company_id) = CURRENT_USER)
                    Rows Removed by Filter: 346893
                    Planning Time: 0.133 ms
                    Execution Time: 185.552 ms
Planning Time: 7.814 ms   
Execution Time: 186.157 ms
**/                                   

explain analyze select COUNT(*) from users where company_id = '001';

/** Result
Aggregate  (cost=406.27..406.28 rows=1 width=8) (actual time=8.036..8.037 rows=1 loops=1)
  ->  Index Only Scan using users_pkey on users  (cost=0.43..406.13 rows=56 width=0) (actual time=1.213..7.405 rows=10525 loops=1)
        Index Cond: (company_id = '001'::text)
        Filter: (concat('sales_company_', company_id) = CURRENT_USER)
        Heap Fetches: 0
Planning Time: 5.907ms
Execution Time: 9.296 ms
**/                                            
```

 - WHERE句を使って明示的に絞り込むのと、絞り込まないのでは、出力結果は同じだがパフォーマンスが異なる
 - WHERE句を明示的に絞り込むとINDEXが効くが、暗黙的だと全件Seq Scanをしてから絞り込む形となる
 - ただし今回複合キーを利用しているが、`PRIMARY KEY(id, company_id)`といったように絞り込むキーを第2PKとかにすると機能しなくなる