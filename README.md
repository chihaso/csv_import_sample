# README
CSVファイルを取り込んでDBにデータを保存するサンプルアプリです。
各市区町村の年ごとの人口データを取り込み、画面上に表示します。

## セットアップ方法
`git clone`等でコードをダウンロード後、下記のコマンドを実行してください
```sh
bin/setup
```

## 取り込めるCSVファイルのサンプル
[sample.csv](https://github.com/chihaso/csv_import_sample/blob/main/sample.csv)
（プロジェクトルートにおいてあります）

## 備考
- あらかじめ登録された市区町村のデータのみ受付けます。
- CSVの中に不備（値が抜けている 、数値であるべきところが文字になっている、など）がある場合、どこのフィールドが間違っているかを表示します。
- CSV読み込み部分(app/models/population/csv/配下)以外はかなり適当です・・・。
