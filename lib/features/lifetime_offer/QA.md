---
feature: lifetime_offer
verification: mobile-mcp
last_verified_commit: e7d4082f35056070b0425056efd6b085b115c752
last_verified_at: 2026-10-09
---

# lifetime_offer QA

利用開始から 1 年ごとの年会費更新前の時期に、割引版の買い切りプラン (または月額 300 円プラン) を期間限定で訴求するオファー。表示条件は Remote Config と利用日数 (335 日 < n < 355 日) に依存し、新規アカウントでは満たせないため、画面の内容は設定タブの開発者オプション「買い切りオファー Paywall」(`lib/features/settings/components/rows/lifetime_offer_paywall_row.dart`) から `ProviderScope` の override で開いて確認する。

確認環境 (2026-10-05 と 2026-10-08 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。

## 関連リンク

- 仕様: `lib/features/lifetime_offer/README.md`
- 関連: `.maestro/flows/lifetime_offer/lifetime_offer_paywall_variants.yaml`

## 1. オファー画面の表示

- [x] **買い切りオファー画面 (解約誘導文言あり)**: 開発者オプションで「解約誘導文言あり」「default」「買い切りプラン」を選ぶと、利用日数・「期間限定の特別価格です！」・残り時間のカウントダウン (初回表示から 24 時間)・月額/年額プラン利用中向けの解約案内・買い切りの価格 ($69.99)・「期間限定の価格で購入する」ボタンが表示される
  - 自動化: auto（.maestro/flows/lifetime_offer/lifetime_offer_paywall_variants.yaml）
- [x] **月額 300 円オファー画面**: 開発者オプションで「月額300円プラン」を選ぶと、「月額プランのご案内です」の文言と月額プランの価格 ($2.99・1ヶ月ごとの自動更新) が表示され、買い切りの価格は表示されない
  - 自動化: manual（開発者オプションのダイアログ選択は座標指定が要り flow 化していない）
- [ ] **閉じる**: 左上の × をタップすると画面が閉じて設定画面に戻る
  - 自動化: manual（同上）
  - ⏭️ スキップ: 2026-10-08 に × をタップして次の操作に進んだが、閉じた後の設定画面のスクリーンショットを撮っておらず、証跡が無いため未確認として残す

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **買い切りオファー画面 (解約誘導文言あり)**: 開発者オプションで「解約誘導文言あり」「default」「買い切りプラン」を選ぶと、利用日数・「期間限定の特別価格です！」・残り時間のカウントダウン (初回表示から 24 時間)・月額/年額プラン利用中向けの解約案内・買い切りの価格 ($69.99)・「期間限定の価格で購入する」ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

「Pilllを使い始めて 1日」「期間限定の特別価格です！」「残り 24:00:00」、月額・年額プラン利用中向けの解約案内 (赤枠)、買い切り $69.99「一度の購入でずっとプレミアム」、「期間限定の価格で購入する」が表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/badd2fa3-9464-41ae-969f-970e5bf8dd0d-settings-lifetime-page.png" width="320">

</details>

### **月額 300 円オファー画面**: 開発者オプションで「月額300円プラン」を選ぶと、「月額プランのご案内です」の文言と月額プランの価格 ($2.99・1ヶ月ごとの自動更新) が表示され、買い切りの価格は表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

「解約誘導文言なし」「default」「月額300円プラン」を選ぶと、「長くご愛顧いただいている皆様へ 月額プランのご案内です」「残り 24:00:00」と月額プラン $2.99「1ヶ月ごとの自動更新」が表示され、解約案内と買い切りの価格は表示されないことを確認 (価格は StoreKit テスト環境のため USD 表記)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/d58887c9-3303-4d2b-9c07-c869ee92cc23-lifetime-offer-monthly300.png" width="320">

</details>

### **閉じる**: 左上の × をタップすると画面が閉じて設定画面に戻る

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 閉じた後のスクリーンショットが無いため未確認 (理由はチェックリスト側を参照)

</details>

</details>

---

## 2. 実際の導線 (利用日数に依存)

- [ ] **お知らせバーからの起動**: 利用日数が条件 (Remote Config の `lifetimeOfferUserCreationDaysSince` < n < `lifetimeOfferUserCreationDaysUntil`。既定 335 < n < 355) を満たすユーザーの記録画面に残り時間付きのバーが常設され、タップするとオファー画面が開く。期限を過ぎるとバーは消える
  - ⏭️ スキップ: 利用日数は Firebase Auth のアカウント作成日時から算出され、QA の新規アカウントでは条件に届かない。`lifetimeOfferEnabled` の既定値も false。判定は `test/features/lifetime_offer/provider_test.dart` で担保している
- [ ] **起動時の自動モーダル**: 条件を満たすユーザーの起動時に周期ごと 1 回だけオファー画面が自動で開き、他の起動時モーダルと重ならない
  - ⏭️ スキップ: 同上。`test/features/root/resolver/show_lifetime_offer_on_app_launch_test.dart` で担保している
- [ ] **購入**: 「期間限定の価格で購入する」で StoreKit の購入フローが始まり、完了するとプレミアムになる
  - ⏭️ スキップ: Sandbox テスターアカウント (Apple Account の認証情報) が無く購入を完了できない。購入ボタンからサインインダイアログまでの遷移は premium_introduction の「購入ボタンタップでローディング表示」と同じ `Purchases.purchase` の経路
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=ALREADY_SLIM` (2026-10-08)
    - デーモン: icloud カテゴリを有効にした状態で、premium_introduction の月額プランは OS の「Apple Account にサインイン」ダイアログに到達しており、デーモン不足ではなく認証情報の不足が原因 (`launchctl list` の出力は取っていない)
    - 試した手順: 本画面の「期間限定の価格で購入する」は未タップ (同じ経路の premium_introduction で止まる箇所が分かっているため)。premium_introduction で月額プラン → サインインダイアログ → 認証情報が無く「キャンセル」で中断

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **お知らせバーからの起動**: 利用日数が条件 (Remote Config の `lifetimeOfferUserCreationDaysSince` < n < `lifetimeOfferUserCreationDaysUntil`。既定 335 < n < 355) を満たすユーザーの記録画面に残り時間付きのバーが常設され、タップするとオファー画面が開く。期限を過ぎるとバーは消える

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 利用日数の条件を満たせないため未実施

</details>

### **起動時の自動モーダル**: 条件を満たすユーザーの起動時に周期ごと 1 回だけオファー画面が自動で開き、他の起動時モーダルと重ならない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 利用日数の条件を満たせないため未実施

</details>

### **購入**: 「期間限定の価格で購入する」で StoreKit の購入フローが始まり、完了するとプレミアムになる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: Sandbox テスターアカウントが無いため未実施

</details>

</details>
