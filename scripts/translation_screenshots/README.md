# 翻訳の画面比較用スクリーンショット

castle の translate-app-screenshot-check skill に渡す入力として、実際のアプリ画面を言語別に撮る。出力は `<画面>/<言語コード>.png` (画面ごとのディレクトリの下に言語の png が並ぶ形)。比較の基準は `ja.png`。

撮影の流れは次のとおり。

1. `.maestro/flows/translation_screenshot/capture.yaml` が初期設定を日本語で突破する
2. 設定タブの開発者オプション「表示言語」で、debug ビルドの文言を撮影する言語に切り替える
3. 主要画面を順に開いて撮る

`scripts/translation_screenshots/capture_langs.sh` が言語ごとに Simulator の言語も同じ言語にしてから flow を回す。`.github/workflows/translation-screenshots.yml` はそれを GitHub Actions の macOS Runner で言語グループごとに並列実行する。

## 撮る画面と仕様

下の表の `record/`・`menstruation/`・`calendar/`・`settings/`・`reminder_notification_customize_word/`・`pill_sheet_setting_sheet/`・`rest_duration_begin_dialog/` は、初期設定の直後に、記録 →「ピルシートを追加」で初期設定のピルの種類のままピルシートを足した状態で撮る。そのため、どの言語でも次の状態になる。

- ピルの種類は 21錠＋7日休薬 × 3 枚 (初期設定で 1 種類を選ぶと 3 枚分が保存される)
- ピルシートは撮影した日に追加したもので、服用の記録は無い
- 服用通知の時刻は初期値
- プレミアムはトライアル中

`yaz_flex_question/`・`pill_sheet_type_select_sheet/` はその後、開発者オプションのユーザー削除で初期設定に戻してから撮る。ピルシートを作る前の初期設定の画面で、上の状態は当てはまらない。

日付・曜日・今日の服用番号は撮影した日によって変わり、言語とは関係しない。日付の書式と Material の組み込み文言 (ダイアログの OK・日付ピッカー等) は端末の言語に従う。capture_langs.sh が端末の言語も撮影言語に揃える。

| ディレクトリ | 画面 | 仕様 |
| --- | --- | --- |
| `record/` | 記録画面 (ピルシート) | ホームの記録タブ。ピルシート・服用記録ボタン・ピルシートの設定ボタン。上部にお知らせの帯 (feature appeal) が出ることがある |
| `menstruation/` | 生理記録 | ホームの生理タブ。生理の記録が無い状態の表示 |
| `calendar/` | カレンダー | ホームのカレンダータブ。今月のカレンダーと服用・生理の予定 |
| `settings/` | 設定 | ホームの設定タブの先頭 (画面に収まる範囲) |
| `reminder_notification_customize_word/` | 服用通知の文言カスタマイズ | 設定 → 服用通知の文言カスタマイズ。通知の文言の入力欄とプレビュー |
| `pill_sheet_setting_sheet/` | ピルシートの設定シート | 記録 → ピルシートの設定。服用お休みを含むメニューのボトムシート |
| `rest_duration_begin_dialog/` | 服用お休みの開始ダイアログ | 記録 → ピルシートの設定 → 服用お休みを開始。服用お休みを始める確認のダイアログ |
| `yaz_flex_question/` | Yaz Flex の初期設定の質問 | 初期設定の最初の画面「ヤーズフレックスの方ですか？」 |
| `pill_sheet_type_select_sheet/` | ピルの種類選択シート | ピルの種類を選ぶボトムシート。記録 →「ピルシートを追加」でも同じ部品 (`AddPillSheetTypeEmpty`) から開くシートで、flow では初期設定の中で開く |

撮らない画面:

- プレミアム紹介: RevenueCat の offering (StoreKit の商品) が取れるまでインジケーターのままで、App Store の商品を取得できない CI の Simulator では表示されない (`.maestro/flows/config.yaml` の `lifetime_offer/` と同じ理由)

## workflow を起動して artifact を取る

```sh
# langs を省くと比較の主要 7 言語 (en,ko,zh,es,pt,de,fr) と基準の ja を撮る。group_count は並列 Runner 数
gh workflow run translation-screenshots.yml -f langs=ja,en,de -f group_count=3

# 起動した run を待つ
gh run watch "$(gh run list --workflow translation-screenshots.yml --limit 1 --json databaseId --jq '.[0].databaseId')"

# artifact translation-screenshots を screenshots/ に取る (screenshots/<画面>/<言語>.png になる)
gh run download <run ID> -n translation-screenshots -D screenshots
```

artifact の保持期間は 7 日。

## ローカルで撮る

dev の debug ビルドを install した起動中の Simulator (iPhone 17) を用意して実行する。

```sh
sh scripts/translation_screenshots/capture_langs.sh --udid <UDID> -l ja,de
```

出力は `scripts/translation_screenshots/artifacts/` (git 管理外)。flow は `clearState` で始め、最後に開発者オプションのユーザー削除を行うため、Simulator の dev アプリのデータは消える。
