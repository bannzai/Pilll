---
feature: feature_appeal
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-05
---

# feature_appeal QA

13種の機能訴求(AnnouncementBar + HelpPage のペア)が `FeatureAppealBarsContainer` で日替わりローテーション表示される。個別機能ごとに実装パターンは共通のため、代表的な訴求フロー(無料機能・プレミアム機能それぞれ1件)を中心に確認する。

## 1. バー表示・ローテーション (共通コンテナ)

- [x] **候補のうち1件のみ表示**: ホーム画面のアナウンスバー領域には feature_appeal の候補(最大13件)のうち1件だけが表示される(日付ベースのローテーションで日替わり)
- [x] **iOS限定機能はAndroidで候補から除外**: Android端末では CriticalAlert・AlarmKit のバーが候補から除外される(設定画面に対応する行がないため)
- [x] **×ボタンで当日は再表示されない**: 表示中のバーの×ボタンをタップすると feature_appeal 領域全体がその日は非表示になる(`featureAppealLastDismissedDate` に当日の日付が保存される)
- [x] **全候補がdismiss済みの場合は領域ごと非表示**: 全機能をdismiss済みにした状態でホーム画面を開くと、feature_appeal 領域が何も表示せず高さ0で折りたたまれる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **候補のうち1件のみ表示**: ホーム画面のアナウンスバー領域には feature_appeal の候補(最大13件)のうち1件だけが表示される(日付ベースのローテーションで日替わり)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

トライアル中ユーザーのホーム画面で `feature_appeal_bar` (生理記録訴求) が1件のみ表示されていることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/4a1dbb6e-6881-418c-8725-d9df27ed4edf.png" width="320">

</details>

### **iOS限定機能はAndroidで候補から除外**: Android端末では CriticalAlert・AlarmKit のバーが候補から除外される(設定画面に対応する行がないため)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

⏭️ この session では Android 実機・エミュレータが用意できないため画面キャプチャは代替できず、代替手段として自動テストで確認した。`flutter test test/features/feature_appeal/feature_appeal_bars_container_test.dart` の `#FeatureAppealBarsContainer` グループが `Platform.isIOS=false` (非iOS) 条件下で `CriticalAlertAnnouncementBar` / `AlarmKitAnnouncementBar` が候補から除外されることを検証しており、13件中13件成功（All tests passed!）。

</details>

### **×ボタンで当日は再表示されない**: 表示中のバーの×ボタンをタップすると feature_appeal 領域全体がその日は非表示になる(`featureAppealLastDismissedDate` に当日の日付が保存される)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

生理記録バーの×ボタンをタップすると feature_appeal 領域は非表示になり、`AnnouncementBar` の次の候補（アカウント登録推奨バー）にフォールバックした。feature_appeal 自体は当日再表示されないことを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/d670e42a-1ba6-447e-a00a-248f17579b6f.png" width="320">

</details>

### **全候補がdismiss済みの場合は領域ごと非表示**: 全機能をdismiss済みにした状態でホーム画面を開くと、feature_appeal 領域が何も表示せず高さ0で折りたたまれる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

⏭️ 13機能すべての dismiss 済み SharedPreferences 状態は実機シミュレータのサンドボックス内 plist を書き換える必要があり本 session のツール制約上直接再現できないため、代替手段として自動テストで確認した。`flutter test test/features/feature_appeal/feature_appeal_bars_container_test.dart` の `13 機能全 dismiss → SizedBox.shrink が表示される` テストで13件全 dismiss 時に全 Bar が `findsNothing` となることを確認済み（13件中13件成功）。

</details>

</details>

---

## 2. HelpPage 表示・内容 (無料機能の例: ピル記録)

- [x] **バータップでHelpPageに遷移**: バーをタップすると対応するHelpPage(例: `RecordPillHelpPage`)に遷移する
- [x] **HelpPageの構成要素表示**: アイコン、見出し、3件のフィーチャーカード、「アプリ内の場所」ラベル、該当タブがハイライトされたモックタブバー、下向き矢印、コンポーネントプレビューが表示される
- [x] **確認するボタンで該当タブへ直接遷移**: 無料機能のHelpPageで「確認する」ボタンをタップすると、ペイウォールを経由せずホーム画面の該当タブ(例: 記録タブ)に直接遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バータップでHelpPageに遷移**: バーをタップすると対応するHelpPage(例: `RecordPillHelpPage`)に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

開発者オプションの「FeatureAppeal AnnouncementBar 一覧」で実際のバー(通知メッセージカスタマイズ)をタップし対応するHelpPageに遷移することを確認。あわせて `RecordPillHelpPage`(ピル記録)にも遷移できることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/1ff198ea-ce53-453c-8aa3-fd92d04a4057.png" width="320">

</details>

### **HelpPageの構成要素表示**: アイコン、見出し、3件のフィーチャーカード、「アプリ内の場所」ラベル、該当タブがハイライトされたモックタブバー、下向き矢印、コンポーネントプレビューが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

`RecordPillHelpPage`(ピル記録)で、アイコン・見出し「服用履歴を簡単に振り返り」・3件のフィーチャーカード・「アプリ内の場所」ラベル・ハイライトされたモックタブバー・下向き矢印・コンポーネントプレビューがすべて表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/1ff198ea-ce53-453c-8aa3-fd92d04a4057.png" width="320">

</details>

### **確認するボタンで該当タブへ直接遷移**: 無料機能のHelpPageで「確認する」ボタンをタップすると、ペイウォールを経由せずホーム画面の該当タブ(例: 記録タブ)に直接遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

無料機能(生理記録)のHelpPageで「確認する」をタップすると、ペイウォールを経由せず設定タブへ直接遷移することを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/02dba706-a101-4dfd-b3bc-c34e7a78f27c.png" width="320">

</details>

</details>

---

## 3. HelpPage 表示・内容 (プレミアム機能の例: AlarmKit)

- [x] **プレミアムバッジ付きプレビュー表示**: プレミアム機能のHelpPage(例: `AlarmKitHelpPage`)には該当設定行のプレビューに `PremiumBadge` が表示される
- [ ] **非プレミアムユーザーは確認するボタンでペイウォール表示**: 非プレミアムユーザーが「確認する」ボタンをタップすると、設定タブへの遷移前に `PremiumIntroductionSheet` が表示される
- [x] **プレミアムユーザーは確認するボタンで直接タブ遷移**: プレミアムまたはトライアル中のユーザーが同じボタンをタップすると、ペイウォールを経由せず設定タブへ直接遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアムバッジ付きプレビュー表示**: プレミアム機能のHelpPage(例: `AlarmKitHelpPage`)には該当設定行のプレビューに `PremiumBadge` が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

プレミアム機能(通知メッセージカスタマイズ、AlarmKit)のHelpPageで、該当設定行のプレビューに `Premium` バッジが表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/85276cc8-9096-4fc9-9bde-969b110f7d53.png" width="320">

</details>

### **非プレミアムユーザーは確認するボタンでペイウォール表示**: 非プレミアムユーザーが「確認する」ボタンをタップすると、設定タブへの遷移前に `PremiumIntroductionSheet` が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

⏭️ スキップ: dev環境で匿名サインアップすると初期設定完了時に自動的に45日間のトライアル(`isTrial=true`)が付与されるため(`lib/provider/user.dart` の `EndInitialSetting`)、本 session 内で「非プレミアム・非トライアル」ユーザー状態を作る手段がない(デバッグ用のプレミアム/トライアル強制トグルは存在せず、Firestore ユーザードキュメントの直接書き換えは QA の範囲外と判断)。コードレビューで `reminder_notification_customize_word_help_page.dart` 等の「確認する」ボタン押下処理に `if (!user.premiumOrTrial) { ... showPremiumIntroductionSheet ... }` のガードが存在することは確認済み。

</details>

### **プレミアムユーザーは確認するボタンで直接タブ遷移**: プレミアムまたはトライアル中のユーザーが同じボタンをタップすると、ペイウォールを経由せず設定タブへ直接遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

トライアル中ユーザー(`isTrial=true`)がプレミアム機能(通知メッセージカスタマイズ)のHelpPageで「確認する」をタップすると、`PremiumIntroductionSheet` を経由せず設定タブへ直接遷移することを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/0441d239-856f-470e-98d6-7023fdcce740.png" width="320">

</details>

</details>

---

## 4. エッジケース・関連導線

- [x] **戻るボタンでHelpPageを閉じる**: HelpPage左上の戻るアイコンでホーム画面に戻れる
- [x] **設定画面の一覧からの個別遷移**: 設定タブの「機能紹介一覧」(`feature_appeal_help_page_list_page.dart`)から、日替わりローテーションに依存せず13件すべてのHelpPageに個別遷移できる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **戻るボタンでHelpPageを閉じる**: HelpPage左上の戻るアイコンでホーム画面に戻れる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

HelpPage(Critical Alert)左上の戻るアイコンをタップし、前画面(呼び出し元一覧)に正しく戻れることを確認。`Navigator.of(context).pop()` のみの単純な実装で、ホーム画面のバー起点でも同様に動作する。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/38c48910-a7d7-4b4e-94d4-7bbbc1521742.png" width="320">

</details>

### **設定画面の一覧からの個別遷移**: 設定タブの「機能紹介一覧」(`feature_appeal_help_page_list_page.dart`)から、日替わりローテーションに依存せず13件すべてのHelpPageに個別遷移できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

「FeatureAppeal HelpPage 一覧」から13件全て(Critical Alert / 通知メッセージカスタマイズ / ピルシート外観モード(date) / ピル記録 / 生理記録 / カレンダー・日記 / 未来の予定 / ヘルスケア連携 / クイックレコード / ピルシート自動追加 / AlarmKit / 今日の服用番号変更 / 服用おやすみ)に個別遷移できることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/e4d73e5e-ee82-4bea-a90b-ce07b4316a8d.png" width="320">

</details>

</details>
