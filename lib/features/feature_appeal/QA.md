---
feature: feature_appeal
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# feature_appeal QA

12種の機能訴求(AnnouncementBar + HelpPage のペア)が `FeatureAppealBarsContainer` で日替わりローテーション表示される。個別機能ごとに実装パターンは共通のため、代表的な訴求フロー(無料機能・プレミアム機能それぞれ1件)を中心に確認する。

## 1. バー表示・ローテーション (共通コンテナ)

- [ ] **候補のうち1件のみ表示**: ホーム画面のアナウンスバー領域には feature_appeal の候補(最大12件)のうち1件だけが表示される(日付ベースのローテーションで日替わり)
- [ ] **iOS限定機能はAndroidで候補から除外**: Android端末では CriticalAlert・AlarmKit のバーが候補から除外される(設定画面に対応する行がないため)
- [ ] **×ボタンで当日は再表示されない**: 表示中のバーの×ボタンをタップすると feature_appeal 領域全体がその日は非表示になる(`featureAppealLastDismissedDate` に当日の日付が保存される)
- [ ] **全候補がdismiss済みの場合は領域ごと非表示**: 全機能をdismiss済みにした状態でホーム画面を開くと、feature_appeal 領域が何も表示せず高さ0で折りたたまれる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **候補のうち1件のみ表示**: ホーム画面のアナウンスバー領域には feature_appeal の候補(最大12件)のうち1件だけが表示される(日付ベースのローテーションで日替わり)

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **iOS限定機能はAndroidで候補から除外**: Android端末では CriticalAlert・AlarmKit のバーが候補から除外される(設定画面に対応する行がないため)

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **×ボタンで当日は再表示されない**: 表示中のバーの×ボタンをタップすると feature_appeal 領域全体がその日は非表示になる(`featureAppealLastDismissedDate` に当日の日付が保存される)

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **全候補がdismiss済みの場合は領域ごと非表示**: 全機能をdismiss済みにした状態でホーム画面を開くと、feature_appeal 領域が何も表示せず高さ0で折りたたまれる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 2. HelpPage 表示・内容 (無料機能の例: ピル記録)

- [ ] **バータップでHelpPageに遷移**: バーをタップすると対応するHelpPage(例: `RecordPillHelpPage`)に遷移する
- [ ] **HelpPageの構成要素表示**: アイコン、見出し、3件のフィーチャーカード、「アプリ内の場所」ラベル、該当タブがハイライトされたモックタブバー、下向き矢印、コンポーネントプレビューが表示される
- [ ] **確認するボタンで該当タブへ直接遷移**: 無料機能のHelpPageで「確認する」ボタンをタップすると、ペイウォールを経由せずホーム画面の該当タブ(例: 記録タブ)に直接遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バータップでHelpPageに遷移**: バーをタップすると対応するHelpPage(例: `RecordPillHelpPage`)に遷移する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **HelpPageの構成要素表示**: アイコン、見出し、3件のフィーチャーカード、「アプリ内の場所」ラベル、該当タブがハイライトされたモックタブバー、下向き矢印、コンポーネントプレビューが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **確認するボタンで該当タブへ直接遷移**: 無料機能のHelpPageで「確認する」ボタンをタップすると、ペイウォールを経由せずホーム画面の該当タブ(例: 記録タブ)に直接遷移する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. HelpPage 表示・内容 (プレミアム機能の例: AlarmKit)

- [ ] **プレミアムバッジ付きプレビュー表示**: プレミアム機能のHelpPage(例: `AlarmKitHelpPage`)には該当設定行のプレビューに `PremiumBadge` が表示される
- [ ] **非プレミアムユーザーは確認するボタンでペイウォール表示**: 非プレミアムユーザーが「確認する」ボタンをタップすると、設定タブへの遷移前に `PremiumIntroductionSheet` が表示される
- [ ] **プレミアムユーザーは確認するボタンで直接タブ遷移**: プレミアムまたはトライアル中のユーザーが同じボタンをタップすると、ペイウォールを経由せず設定タブへ直接遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアムバッジ付きプレビュー表示**: プレミアム機能のHelpPage(例: `AlarmKitHelpPage`)には該当設定行のプレビューに `PremiumBadge` が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **非プレミアムユーザーは確認するボタンでペイウォール表示**: 非プレミアムユーザーが「確認する」ボタンをタップすると、設定タブへの遷移前に `PremiumIntroductionSheet` が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **プレミアムユーザーは確認するボタンで直接タブ遷移**: プレミアムまたはトライアル中のユーザーが同じボタンをタップすると、ペイウォールを経由せず設定タブへ直接遷移する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 4. エッジケース・関連導線

- [ ] **戻るボタンでHelpPageを閉じる**: HelpPage左上の戻るアイコンでホーム画面に戻れる
- [ ] **設定画面の一覧からの個別遷移**: 設定タブの「機能紹介一覧」(`feature_appeal_help_page_list_page.dart`)から、日替わりローテーションに依存せず12件すべてのHelpPageに個別遷移できる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **戻るボタンでHelpPageを閉じる**: HelpPage左上の戻るアイコンでホーム画面に戻れる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **設定画面の一覧からの個別遷移**: 設定タブの「機能紹介一覧」(`feature_appeal_help_page_list_page.dart`)から、日替わりローテーションに依存せず12件すべてのHelpPageに個別遷移できる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
