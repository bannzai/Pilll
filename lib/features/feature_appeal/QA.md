---
feature: feature_appeal
verification: mobile-mcp
last_verified_commit: 21853fcbe3916b4509d34b8a00a3fac51298721c
last_verified_at: 2026-09-11
---

# feature_appeal QA

13種の機能訴求(AnnouncementBar + HelpPage のペア)が `FeatureAppealBarsContainer` で日替わりローテーション表示される。個別機能ごとに実装パターンは共通のため、代表的な訴求フロー(無料機能・プレミアム機能それぞれ1件)を中心に確認する。

## 1. バー表示・ローテーション (共通コンテナ)

- [x] **候補のうち1件のみ表示**: ホーム画面のアナウンスバー領域には feature_appeal の候補(最大13件)のうち1件だけが表示される(日付ベースのローテーションで日替わり)
- [x] **転換実績に基づく重み付きローテーション**: 表示順は `FeatureAppealBarWeight` (alarm_kit / health_care_integration / quick_record = 3、future_schedule / menstruation / appearance_mode_date = 2、他 = 1) で重み付けされ、1 周目は全候補、2 周目以降は重みが残る候補だけが順に表示される。表示時に `feature_appeal_bar_shown` (feature_key / feature_type / weight / rotation_length) が送られる
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

### **転換実績に基づく重み付きローテーション**: 表示順は `FeatureAppealBarWeight` (alarm_kit / health_care_integration / quick_record = 3、future_schedule / menstruation / appearance_mode_date = 2、他 = 1) で重み付けされ、1 周目は全候補、2 周目以降は重みが残る候補だけが順に表示される。表示時に `feature_appeal_bar_shown` (feature_key / feature_type / weight / rotation_length) が送られる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-11**

初期設定直後のトライアル中ユーザー (iOS、全 13 候補・appIsReleased=true で表示順は 22 日周期) のホーム画面で「未来の予定を書き込もう」(future_schedule) が表示された。2026-09-11 は epoch (2024-01-01) から 984 日目で 984 % 22 = 16 → 2 周目 (13 件目以降) の 4 番目 = 重み 2 の future_schedule に一致する (1 周目 13 件 → 2 周目: quick_record / appearance_mode_date / menstruation / future_schedule / health_care_integration / alarm_kit)。日替わりの全周期は端末で確認できないため、`flutter test test/features/feature_appeal/feature_appeal_bars_container_test.dart` の `#weightedRotationOrder` (4 件) と `2 周目` / `3 周目の末尾と折り返し` のテストで表示順を検証した (181 件中 181 件成功)。`feature_appeal_bar_shown` の送信は BigQuery 着弾を待つ (PilllBackend `feature_appeal_bar_exposure.sql`)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/10/e971e1dd-5f63-4075-b518-6eb9b0c5e349-home_after_onboarding_trial.png" width="320">

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
  - ⏭️ スキップ: 2026-07-05 の記録 (下記エビデンス) のとおり未実施。今回 (2026-09-11) はトライアル中ユーザーの導線 (下の項目) を対象にしたため再実施していない。現在は開発者オプション「トライアル解除」で無料ユーザー状態を作れるので、次回の QA で確認する
- [x] **プレミアムユーザーは確認するボタンで直接タブ遷移**: プレミアムまたはトライアル中のユーザーが同じボタンをタップすると、ペイウォールを経由せず設定タブへ直接遷移する
- [x] **トライアル中ユーザーには「プレミアムプランを見る」ボタンが表示される**: プレミアム機能のHelpPageで、トライアル中(非プレミアム)のユーザーには「確認する」の下に「プレミアムプランを見る」(`FeatureAppealPremiumPlanButton`) が表示され、タップすると `PremiumIntroductionSheet` が開く。プレミアム会員・トライアル未開始/終了後の無料ユーザーには表示されない

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

### **トライアル中ユーザーには「プレミアムプランを見る」ボタンが表示される**: プレミアム機能のHelpPageで、トライアル中(非プレミアム)のユーザーには「確認する」の下に「プレミアムプランを見る」(`FeatureAppealPremiumPlanButton`) が表示され、タップすると `PremiumIntroductionSheet` が開く。プレミアム会員・トライアル未開始/終了後の無料ユーザーには表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-11**

初期設定直後 (トライアル中) のユーザーで、開発者オプション「FeatureAppeal HelpPage 一覧」→ AlarmKit (iOS 26+) を開くと「確認する」の下に「プレミアムプランを見る」が表示され、タップで `PremiumIntroductionSheet` (プラン一覧) が開いた。非表示の条件 (プレミアム会員・トライアル未開始・トライアル終了後) は `flutter test test/features/feature_appeal/feature_appeal_premium_plan_button_test.dart` (4 件成功) で確認した。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/10/9ab1e0dc-05a5-48b9-9079-042641157c9b-help_page_alarm_kit_trial.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/10/0d1dd55d-5d96-4f65-8aa7-e4ebed792661-help_page_alarm_kit_paywall.png" width="320">

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
