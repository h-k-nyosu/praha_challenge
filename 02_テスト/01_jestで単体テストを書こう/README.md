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

## sumOfArrayの空配列の挙動

- 好ましくない理由は例外であることを明示されていないことと、処理が止まってしまうため（要件次第だが）。空の場合は0を返すことにすればこちら側でいかようにも考慮することができる。

```js
export const sumOfArray = (numbers: number[]): number => {
    if (numbers.length === 0) {
        return 0;
    }
    return numbers.reduce((a: number, b: number): number => a + b);
};

```

## Property Base Testingについて

- これはランダムな値を多数入力して、その結果が適切な挙動となっているかをテストする方法のこと。これにより特定の値の時だけ不具合が起きる、といった複雑なプログラムにおいて見落としてしまいがちなケースを網羅しやすくする
- これを採用すべきケースは、複雑なプログラムの場合や、エッジケースを洗い出した後に品質を向上させる観点で、追加で加えるなどはありえそう。
- 採用しない方が良いケースは、`Property Base Testing`で挙動を確かめるために、テストコードが非常に複雑になってしまうケースは採用しない方が良いと考える。テストコード自体が合っているかの担保が難しくなってくるため


## 単体テスト増加における可読性・保守性・実行速度への対策

- test as documentとして機能させる。具体的には1回につき一つのテストにして理解しやすい仕様にしたり、命名から何を意味しているのか分かりやすくする（ドキュメントを読むように理解ができる）。
- SUT（テスト対象）を疎結合にする。密結合にするとSUTに変更が加わったときに様々なテストに影響が出てしまい維持コストが膨らんでしまう。また疎結合の場合はSUTをブラックボックスと見立てて、Publicメソッドに対してテストを実施するのがBetter。Publicメソッドで呼び出されるPrivateメソッドは、Public Testで結果的にカバーできる。そのため改修頻度が高いものであっても、メンテナンスコストは低く収まる。
- DRY(Don't Repeat Yourself)の原則を守り、調布コードを排除する


ref：https://speakerdeck.com/hgsgtk/practices-to-write-better-unit-test

# 課題4

## 単体テスト
[こちらのファイルに関数が記載されています](quote-functions.ts)

```sh
npm install --dev

npm run test
```