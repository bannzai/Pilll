# Pilll Custom Product Page 設計

設計根拠: tmp/research/report.md（競合 15 アプリ × 10 ロケールのストア調査、2026-07 実施）の「5-B. CPP アングル候補」。
App ID: 1405931017。promotionalText の 170 文字制約・適用は appstore-custom-product-page skill を参照。

## 共通方針

- CPP の name は `{訴求軸}-{作成年月}` 形式（App Analytics 上の内部識別名）
- 全 CPP `visible: false` で作成し、審査承認後に流入元（Apple Search Ads・SNS・キーワード割当）ごとに有効化を判断する
- スクリーンショットは scripts/generate_screenshots の CPP バリアント（`_variant-cpp-{軸}`）で全ロケール生成する。v1 は main バリアントと同じ 7 ページ・同じコピーのまま、各軸の主役ページを 1 枚目に並べ替える（軸ごとの差別化は promotionalText と表示順で行う）。コピーの軸専用差し替えは App Analytics の効果測定後に v2 として検討する
- ロケールは reminder / privacy / menstruation / beginner の 4 CPP が、fr-FR を含むスクショ基盤の全 31 代表 ASC ロケール（lib/features/appstore_screenshot/screenshot_locale.dart が SSOT）をカバーする。ru は撮影比較専用で ASC へは配置しない。birthcontrol は英語圏検索語（birth control）専用軸のため en-US のみとする

## CPP 一覧

### 1. reminder-202607（飲み忘れ防止・王道）
- 対象: 「ピル リマインダー」「避妊薬 飲み忘れ」等の検索意図・Search Ads
- 仮説: 直接競合（myPill/Lady Pill 等）は素の UI スクショのままで、デザインされた「確実に飲める」訴求を出すだけで CVR で勝てる
- 1枚目: 複数回リマインド（p4）→ ピルシート（p2）→ 通知+社会的証明（p1）の順
- variant: `cpp-reminder`
- 例外: ja のみ従来の App Store 掲載スクショ（cpp/assets/ja-appstore-202607、2688×1242 横長 4 枚 = APP_IPHONE_65）を使う。
  メイン商品ページを新スクショへ差し替えた後も、日本の飲み忘れ防止軸では実績ある従来訴求を維持して比較するため。
  従来スクショはメイン反映後にストアから取得できなくなるため、リポジトリに保存している

### 2. privacy-202607（伏せた通知・独自性最強）
- 対象: 家族・同居人にピル服用を知られたくない層（学生・若年層）。SNS 流入・「ピル バレたくない」系検索
- 仮説: 「ピルを伏せた通知」は競合に無い Pilll 唯一のフックであり、この不安を持つ層には最初に見せると刺さる
- 1枚目: 伏せた通知（p3）を主役に
- variant: `cpp-privacy`

### 3. menstruation-202607（生理管理・クロスセル集客）
- 対象: 「生理管理アプリ」「生理予測」の検索ボリューム最大ゾーン。ルナルナ/Flo の集客語を拾う
- 仮説: 生理管理目的の流入者にも「ピルも管理できる」提案で差別化できる
- 1枚目: 生理管理（p5）を主役に、ピンク基調
- variant: `cpp-menstruation`

### 4. beginner-202607（ピル服用スタート・初心者）
- 対象: 「ピル 始めた」「ピル 飲み方」等、服用開始直後の不安層
- 仮説: シート UI で「何番目か・休薬いつか」が直感でわかる安心感がオンボーディング層に効く
- 1枚目: ピルシート（p2）を主役に
- variant: `cpp-beginner`

### 5. birthcontrol-202607（英語圏 Birth Control・中長期）
- 対象: en-US の `birth control` / `pill reminder` 検索。us subtitle 未設定の穴埋めと並行する海外展開の起点
- 仮説: Natural Cycles（医療権威）とは別軸の「シンプル服薬＋伏せ通知」で英語圏に入れる
- ロケール: en-US のみ（英語圏検索語専用軸のため）
- variant: `cpp-birthcontrol`

## 効果測定

App Analytics で CPP ごとの impressions / downloads / CVR を計測（初回 DL 5 件以上で表示）。aso-analytics-explorer skill での定点観測と往復する。

## キーワード割当（2026-07-20 追加）

方針: キーワードは原則設定する（bannzai/castle#197）。広告はほぼ出さないため、キーワードごとに
見せ方を変えたページでオーガニック検索流入を広げることが CPP の主目的。

- 割当プールは「最新の承認済みバージョンの keywords」のみ。割当は config.json の各 locale の
  `keywords` が SSOT（新バージョン承認で割当がリセットされるため、承認後に config から再適用する）
- 分類基準: 忘れ/リマインド/通知/アラーム/服薬系→reminder、生理/周期/カレンダー/PMS系→menstruation、
  ピル銘柄名・避妊薬系→beginner、en-US の birth control 系→birthcontrol
- 例外（未設定）: privacy はプールに関連語が無いため全ロケール未設定。fr-FR は承認済み
  バージョンにローカライズ自体が無くプールが空のため、新バージョン承認後に検討する
