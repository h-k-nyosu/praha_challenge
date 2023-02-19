# 課題1

下記のjest公式ドキュメントを読み進めた
 - [Getting Started](https://jestjs.io/ja/docs/getting-started)
 - [Using Matchers](https://jestjs.io/ja/docs/using-matchers)
 - [Testing Asynchronous Code](https://jestjs.io/docs/asynchronous)
 - [Setup and Teardown](https://jestjs.io/docs/setup-teardown)
 - [Mock Functions](https://jestjs.io/docs/mock-functions)

# 課題2
以下のリポジトリにて、jestのテストを作成中
 - [praha-challenge-templates/jestSample/](https://github.com/h-k-nyosu/praha-challenge-templates/tree/master/jestSample)
 - `__tests__`ディレクトリにテストファイルは格納しています

# 課題3
上記の単体テストを書くためには、依存性の注入とモック化を行う必要がありました
そもそも、なぜ元の関数はカバレッジ100%のテストを書けなかったのでしょうか？
依存性の注入とは何でしょうか？どのような問題を解決するために考案されたのでしょうか？

## なぜ元々の関数はカバレッジ100%のテストを書けなかったのか？

 - 外部のコンポーネントに依存しているため。動的に変化する値を返却するものである場合は、テスト結果が毎回変わってしまい検証することが困難になる。

## 依存性の注入とは？
 - テストをしたいプログラムAが、別のプログラムBに依存している状態（プログラムAの内部でインスタンス生成している等）の時、プログラムAに問題がなくてもプログラムBに問題があればテストに引っ掛かってしまう。つまりテストしたいプログラムA単体を純粋にテストすることができなくなってしまう可能性がある
 - これを解決するための手法として依存性の注入がある
 - 依存しているプログラムBを、外部から引数として渡してあげることで、テスト容易性をあげる方法である
 - こうするとテストするときにはプログラムBを、意図する静的な挙動をするモックとして渡してあげることで、プログラムAを単体テストすることができる

```js
export const asyncSumOfArraySometimesZero = (
  numbers: number[],
  database: DatabaseMock
): Promise<number> => {
  return new Promise((resolve): void => {
    try {
      const database = new DatabaseMock(); // ここが外部に依存する要素で問題
      database.save(numbers);
      resolve(sumOfArray(numbers));
    } catch (error) {
      resolve(0);
    }
  });
};
```

```js
let sum = asyncSumOfArraySometimesZero([1,2,3]);
export const asyncSumOfArraySometimesZero = (
  numbers: number[],
  database: DatabaseMock //引数として渡しちゃう
): Promise<number> => {
  return new Promise((resolve): void => {
    try {
      database.save(numbers);
      resolve(sumOfArray(numbers));
    } catch (error) {
      resolve(0);
    }
  });
};

let sum = asyncSumOfArraySometimesZero([1,2,3], new DatabaseMock());

```


## 外部サービスの通信によるデメリット

 - API利用にコストがかかってしまう
 - ネットワーク環境によってエラーが発生してしまう可能性がある
 - API側に問題があるとテストに引っ掛かってしまう
 - API側との通信がうまくいかない場合のエラーハンドリングのテストが実際のAPIを利用すると難しいケースがある



sumOfArrayに空の配列を渡すと例外が発生します。あまり好ましい挙動ではありませんね
なぜあまり好ましい挙動ではないでしょう？
「こうなるべきだ」とご自身が考える形にコードを修正してみてください
ヒント：reduceの初期値に0を設定する、空配列だったら即座に0を返すなど、実行時例外が発生しない形に修正できないでしょうか？
コードを修正したら、先ほど書いた単体テストが落ちるはずです。全ての単体テストが通るよう、単体テストも修正してください


単体テストを作成する際は、挙動が変わる境界値を検討したり、テストで保証しなければならない挙動を開発者自身が事前に考えておく必要があります
しかし複雑な機能をテストする場合あらかじめ全てのテストケースを開発者が想定しきることは難しいかもしれません。「この特定の値の時だけ不具合が起きる」ケースを開発者が見落としてしまうと、テストケースが不完全になってしまいます
そんな時に役立つかもしれない概念として「Property Based Testing（プロパティベースのテスト）」があります（対照的な存在としてはExample Based Testingが挙げられます）
なぜこのテストの考え方がコード品質を向上してくれる可能性があるのでしょうか？逆に採用しない方が良いケースはあるのでしょうか？


単体テストケースを増やしても可読性、保守性、実行速度などに問題が起きないよう工夫できることを3つ考えてみましょう
例：arrange-act-assertパターンを採用する、など
ヒント：特定の領域に関するベストプラクティスを探すときは「〇〇」と「pattern」といった単語を組み合わせて検索してみると役立つ知識が集めやすいかもしれません。今回の例だと「unit test pattern」とか！

