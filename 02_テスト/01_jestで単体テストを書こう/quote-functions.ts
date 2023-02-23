// 素数判定
function isPrimeNumber(num: number): boolean {
    if (num <= 1) {
        return false;
    }
    for (let i = 2; i < num; i++) {
        if (num % i === 0) {
            return false;
        }
    }
    return true;
}

// 名言を取得する
async function fetchRandomQuote(): Promise<string | undefined> {
    const url = 'https://zenquotes.io/api/random';

    try {
        const response = await fetch(url); // fetch APIを使用してAPIにリクエスト
        const data = await response.json(); // レスポンスをJSON形式でパース
        if (Array.isArray(data) && data.length > 0 && data[0].q) {
            return data[0].q; // 名言を含むオブジェクトから名言部分を取得して返す
        } else {
            throw new Error('Invalid API response');
        }
    } catch (error) {
        console.error('Error:', error);
        return undefined;
    }
}

// 最小値と最大値を指定してランダムな整数を返す
function getRandomInt(min: number, max: number): number {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
