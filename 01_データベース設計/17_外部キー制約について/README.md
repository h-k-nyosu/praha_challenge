# 課題1

## 親子関係にあるデータに外部キー制約を一切定義しないとどうなるか？

 - データの不整合が起きる可能性がある
    - 例えば「Book」「Author」テーブルがあり、Bookに1つのAuthorから紐づくケースを想定したときに、Book.author_idのデータが、Author.idに存在しないというケースが存在するリスクがある（バリデーションが効かないため）


## 逆に外部キー制約を定義することで起きる問題は？

 - 参照アクションを定義しないと、外部キーとして利用されているキーのUPDATEが困難となる
 - 参照アクションを定義しないと、外部キーとして利用されているキーのDELETEが困難となる
 - 相互参照という形式で設計してしまうと、アプリケーション側のロジックが複雑になってしまう恐れがある
 - 時系列が考慮されていないと、シンプルなINSERTができないというケースが出てくる



# 課題2


## 選択可能な参照アクション（MySQL）

### RESTRICT
 - 親テーブルに対する削除または更新操作を拒否する。RESTRICT (または NO ACTION) を指定することは、ON DELETE または ON UPDATE 句を省略することと同じ。
 - NO ACTIONとの違いは、こちらは即時外部キー制約チェックが走るということ。
 - MySQLだと、NO ACTION（DEFAULT）と同じなので、一時的な不整合すらも許容しない形で参照整合性を保ちたいというときにRESTRICTを指定する

### SET NULL
 - 参照されている親テーブルのレコードが削除されると、それを参照しているレコードの該当キーをNULLに置き換えるオプション
 - 親テーブルのレコードを削除したいが、子テーブルのレコードは削除したくなく、また外部キーを更新もしたくないという時に利用する

### CASCADE
 - 親テーブルの行を削除または更新し、子テーブル内の一致する行を自動的に削除または更新する
 - 外部キー制約で参照整合性を保ちつつ、柔軟に変更を加えられるようにしたいときはCASCADEを利用する
 - UPDATE/DELETEの２種類があるので、親テーブルの行を更新/削除したときに、子テーブルも更新/削除すべきかは検討が必要となる

### NO ACTION
 - RESTRICTと同様に、親テーブルに対する削除または更新操作を拒否する
 - 外部キー制約の参照アクションを何も指定しない場合、MySQLではデフォルトで設定される
 - RESTRICTとの違いは、遅延外部キー制約チェックであるということ。これはトランザクションの最後に外部キー制約チェックが入る
 - そのため相互参照しているテーブルで、トランザクション内での一時的な不整合を許容したい場合に有効



## 従業員管理サービス
 - この場合、部署の編成に当たって従業員データが削除される恐れがある


## プロジェクトマネジメントツール
 - 担当者（ユーザー）を削除すると（例えばアカウント削除など）、子テーブルのIssueテーブルの行に`SET NULL`しようとして、NULL不許容なためエラーが発生する
 - そのため親テーブルが`ON DELETE（UPDATE） SET NULL`だと、子テーブル側ではNULLを許容せざるを得なくなることなどの影響が発生する


## ORMの参照アクションのデフォルト値について比較
 - prismaの場合
    - オプショナルな関係（子テーブルがNULL許容）では、OnDeleteは`SET NULL`、OnUpdateでは`CASCADE`が適用される
    - 必須な関係では、OnDeleteは`CASCADE`、OnUpdateでは`CASCADE`が適用される
    - ref: https://www.prisma.io/docs/concepts/components/prisma-schema/relations/referential-actions#referential-action-defaults
- TypeORMの場合
    - OnDELETEは`RESTRICT`、変更におけるCASCADEはデフォルト`false`となっていた。`true`にすると`INSERT`っぽい？
    - ref: https://github.com/typeorm/typeorm/blob/master/docs/relations.md

## MySQLとPostgreSQLのrestrictとno actionの違い
 - 外部キー制約のチェックのタイミングが異なる
 - no actionは遅延チェックをする。トランザクションの最後で検査が走るためトランザクション内の一時的なデータ不整合を許容する
 - restrictは即時チェックする。そのため同一トランザクション内であってもデータ不整合が発生すれば検査に引っかかる
 - no actionで遅延チェックをする際に、インデックスが張られていないと全件チェックが走って時間がかなりかかるインシデントにつながる恐れがある
 - ref: https://qiita.com/masudakz/items/ecbfc0f4ace2a7cef0f0


# 課題3

外部キー制約に関するクイズを3問作成してみてください

## リレーショナルデータベースにおける外部キー制約の目的は何ですか？

```
a. テーブル間の参照整合性を強制するため。

b. テーブルのデータの一貫性を強制するため。

c. テーブルのデータセキュリティを強化する。
```

## 2. 外部キー制約におけるCASCADEとSET NULLの参照アクションの違いは何ですか？
```
a. CASCADEは親レコードが削除または更新されたときに対応する子レコードを削除または更新し、SET NULLは親レコードが削除されたときに子レコード内の外部キーをNULLに設定する。

b. CASCADEは親レコードが削除または更新されたときに子レコードの外部キーをNULLに設定し、SET NULLは親レコードが削除または更新されたときに対応する子レコードを削除または更新する。

c. 外部キー制約におけるCASCADEとSET NULLの参照操作に違いはない。
```

## 3. MySQL, PostgreSQLの外部キー制約に対するデフォルトの参照アクションは何ですか？
```
a. CASCADE

b. RESTRICT

c. NO ACTION
```