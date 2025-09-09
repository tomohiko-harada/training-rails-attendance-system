# 勤怠記録システム

## 課題の要件
- https://jmty.kibe.la/notes/38139
- 機能
  - ユーザー登録/ログイン/ログアウト
  - 勤怠打刻
    - 1日に1回、出勤ボタン→休憩開始ボタン(任意)→休憩終了ボタン(任意)→退勤ボタン　の順に打刻することができます
  - 勤怠履歴閲覧
    - 各種打刻の記録を月毎に確認できます
    - 休憩時間が記録されていない場合は、自動で1時間の休憩として集計します
    - 拘束時間、休憩時間、労働時間の月合計を表示します
    - 上部のプルダウンで表示する月を変更可能です
  
## アプリケーションの設計
- https://jmty.kibe.la/notes/38140


## 動作環境
- Rails 7.0.6
- Ruby 3.2.2
- Bootstrap 5.3

## デプロイ
- Herokuにデプロイ
- https://training-jmty-attendance-1da52fd08dc9.herokuapp.com/

## 環境構築
- Dockerを使用しています。
```
docker compose build
```
```
docker compose up -d
```

- db:seedを実行することで、メールアドレスが`test@jmty.jp`、パスワードが`password`の、過去40日分が打刻されたユーザーが生成されます。
