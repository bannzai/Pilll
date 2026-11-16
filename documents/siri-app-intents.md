# Siri・ショートカット向けの App Intent

Siri とショートカットアプリから呼べる操作は `ios/Runner/RecordPillIntent.swift` に置く。処理の流れと文言の置き場所は同ファイルと `ios/Runner/AppDelegate.swift` の `recordPillFromAppIntent`、`lib/native/channel.dart` の `recordPillFromAppIntent` のコメントに書いている。

## `@AppIntent(.tool)` を今付けない理由

Siri AI (iOS 27.3 のベータで開発者向けの先行プレビューが始まった新しい Siri) がアプリの intent を呼ぶには、intent に `@AppIntent(.tool)` マクロを付ける必要がある。今は付けていない。

- 出荷用のビルドを作る Xcode の SDK にこのマクロが無く、付けるとコンパイルできない
  - Xcode 27.1 (27A9275) の iPhoneOS の SDK: 2026-11-16 に `AppIntents.framework` の `arm64e-apple-ios.swiftinterface` を `ToolIntent` と `AppIntent(.tool` で検索し、どちらも見つからないことを確かめた
  - Xcode 27.2 beta の iPhoneOS27.2.sdk: bannzai/Focus の PR https://github.com/bannzai/Focus/pull/1327 の調査で、無いと報告されている (このリポジトリでは確かめていない)
- 先行プレビューは App Store 版と外部 TestFlight では動かない (出典: https://developer.apple.com/documentation/appintents/siri-ai-developer-preview 。issue https://github.com/bannzai/Pilll/issues/2166 の記載による)

## 付けられるようになる条件

iOS 27.3 の SDK を含む Xcode で出荷用のビルド (App Store に提出するビルド) を作れるようになること。その時に `RecordPillIntent` へマクロを付ける。今のうちに済ませているのは、今のツールチェーンで出荷できる範囲 (intent・`AppShortcutsProvider` への発話の登録・`title`・`description`) まで。

## Simulator での確かめ方

- ショートカットアプリの一覧に出る App Shortcut のタイル (「ピルを記録」) は、Simulator では実行できず「Unable to run App Shortcut」になる。アプリが起動中でも終了状態でも同じだった (2026-11-16 に GitHub Actions の runner の Simulator で確認)。bannzai/Focus の PR https://github.com/bannzai/Focus/pull/1327 は、Simulator 向けの署名に Team ID が無いことを OS が拒否するためと報告している (このリポジトリではログを取れず、原因は確かめていない)
- intent の動作は、ショートカットアプリで新しいショートカットを作り、アクション検索から Pilll のアクションを足して実行すると確かめられる。アプリを終了した状態から実行して、記録と返答まで動くことを同じ日に確認した
