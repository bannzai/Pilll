---
status: launched          # evaluating | building | launched | pivoting | retiring | retired
decision_date: 2026-10-28 # 次の判定日 (YYYY-MM-DD)。判定のたびに cycle_days 後へ進める
cycle_days: 14            # 判定の周期 (7 または 14)
veto_wait_hours: 12       # 公開後の無人ループの拒否権の待ち時間 (既定 12)
daily_issue_cap: 3        # 1 日に生成してよい改善 issue の上限 (意味の門。既定 3)
launched_at: 2018-07-29   # 公開日 (YYYY-MM-DD)。App Store の初回公開日
---

# 方向性: Pilll

## 仮説

ピルを服用している日本の人が抱える「飲み忘れたかも」「今日はシートのどれを飲むか」「生理はいつ来るか」という毎日の不安を、服用リマインダー・ピルシートの在庫管理・生理予測・体調記録を 1 つにしたアプリで解消する。海外アプリのローカライズ版が合わず、本格的な生理管理アプリまでは要らない層を狙う (出典: `ios/fastlane/metadata/ja/description.txt`)。

## 判定基準

| 指標 | 計測元 (skill / コマンド) | 継続のしきい値 | 打ち切り条件 | 転換の条件 |
| --- | --- | --- | --- | --- |
| App Store JP 平均評価 | appstore-research skill: `bash ~/.agents/skills/appstore-research/scripts/fetch-app-metadata.sh 1405931017 --country jp` の `averageUserRating` | >= 4.0 | < 3.5 x2 | 評価は保てているが直近 14 日の新規レビューが 2 回連続 0 件なら、獲得 (ASO・オンボーディング) 側の転換を検討する |
| 直近14日の★1〜2レビュー数 | appstore-research skill: `bash ~/.agents/skills/appstore-research/scripts/fetch-reviews.sh 1405931017 --country jp --pages 1` の出力で `date` が直近 14 日かつ `rating` が 2 以下の行数 | <= 1 | >= 3 x2 | 低評価の内容が同じ機能に集中していたら、その機能の作り直しを改善 issue の最優先にする |
| 直近14日のFATALクラッシュissue数 | firebase-crashlytics-triage skill: `bash ~/.agents/skills/firebase-crashlytics-triage/scripts/crashlytics.sh top-issues --config ios/Firebase/GoogleService-Info-prod.plist --days 14 --error-types FATAL` の topIssues の行数 | <= 10 | > 50 x2 | 上位 issue のイベント数が 1 件で 100 を超えていたら、機能追加より先にその修正 issue を出す |
| MRR (USD) | bannzai/dashboard の RevenueCat の日次の値: `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/Pilll --metric mrr --field mrr` | >= 4000 | < 3500 x2 | しきい値を下回り、同じ期間の新規顧客 (`--metric new_customers --field new_customers --days 14 --agg sum`) も減っていたら獲得側、新規顧客が保てていたら課金導線側の転換を検討する |
| D7リテンション (直近14日のコホート平均) | bannzai/dashboard の Firebase Analytics の日次のコホート: `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/Pilll --metric retention --field d7_rate --days 14 --agg avg` | >= 0.38 | < 0.30 x2 | しきい値を下回り、同じ期間の初期設定の完了率 (`--metric onboarding_funnel` の `steps.02_end_initial_setting` / `cohort_users`) も下がっていたら、初期設定の作り直しを改善 issue の最優先にする |

## 必要な機能

- [x] 服用記録とピルシート管理 (v1 / v2、連続服用の休薬)
- [x] 服用リマインダー (複数時刻・通知文言のカスタマイズ・Critical Alert・AlarmKit)
- [x] 生理の記録と予測
- [x] カレンダー・体調記録・予定
- [x] プレミアム (RevenueCat。ピルシート自動追加・クイックレコード等) と課金導線 (FeatureAppeal / lifetime offer / special offering)
- [x] 問い合わせ・ストアレビュー依頼・リリースノート
- [x] 1 日 2 回服用する薬の記録 (ジエノゲスト等。ピルシート追加時に服用回数を設定し、1 回ごとに記録する。202608.04.x で配布。`lib/features/release_note/release_note.dart`)
- [ ] 連続服用モード (ヤーズフレックス等。シート番号とサイクル日数を分け、上限日数・休薬を扱う。方針 bannzai/PilllBackend#498、MVP1 仕様 bannzai/PilllBackend#499)
- [ ] オンボーディングの改善 (課金導線の A/B テスト結果の反映。bannzai/PilllBackend#418)
- [ ] AdMob メディエーション設定の見直し (bannzai/PilllBackend#419)
- [ ] FeatureAppeal の効果測定 (bannzai/PilllBackend#374)

## デザインの方向

既存アプリのため Claude Design のモックは無い。現行の画面を正とし、変更は既存のトーン (`lib/features/` の実装) に合わせる。

## 決めたこと

| 日付 | 場面 | 決めたこと | 決めた人 |
| --- | --- | --- | --- |
| 2026-09-29 | 既存アプリへの後付け | 下書きを agent が作成。bannzai が直すか黙認する。しきい値は 2026-09-29 時点の実測 (平均評価 4.66 / 5954 件、直近 14 日の ★1〜2 レビュー 0 件、直近 14 日の FATAL issue 4 件) を基準に「現状維持なら継続、明確に落ちたら打ち切り」で置いた | agent |
| 2026-10-15 | 判定日 2026-10-13 の判定 | 継続。平均評価 4.66 / 6006 件 (>= 4.0)、直近 14 日の ★1〜2 レビュー 1 件 (<= 1。しきい値の端)。直近 14 日の FATAL クラッシュ issue 数は firebase CLI のログインが切れていて計測できず (UNMEASURED)、残り 2 指標で判定した。打ち切り条件 (> 50 x2) は前回の記録が無いため今回の値に関わらず当たらない。指標の値は `documents/loop/metrics-2026-10-13.json` | agent |
| 2026-10-26 | issue の読み書き先の変更 (bannzai/Pilll#1914) | 公開後の無人ループの記録を bannzai/PilllBackend#491 から bannzai/Pilll#1945 へ移した。2026-10-18 までの記録は bannzai/PilllBackend#491 に残る | agent |
| 2026-10-27 | 判定基準への売上・利用の指標の追加 | bannzai/dashboard に Pilll の RevenueCat と Firebase Analytics の日次の値が集まっていたため、MRR と D7 リテンションを判定基準に足した。仮説 (毎日の不安の解消) が当たっていれば使い続ける人が残るため D7 リテンションを、事業として続けられるかを MRR で見る。新規顧客は 2026-10-17 から first_open が日 200 前後から 400〜800 に増えて揺れが大きいため、転換の条件の切り分けにだけ使う。しきい値は 2026-10-27 時点の実測 (MRR 4205.26 USD (2026-10-25)、直近 90 日の平均 4140.25、直近 30 日の範囲 4150〜4205。D7 リテンションの直近 14 日の成熟したコホート 7 日分の平均 0.434、日ごとの範囲 0.39〜0.51) を基準に「現状維持なら継続、明確に落ちたら打ち切り」で置いた | agent |

## agent に任せること

文書に無い問いはすべて。issue の読み書き先は bannzai/Pilll (`AGENTS.md`「issue の読み書き先」)。Android (Google Play) の指標は計測元が castle の skill に無いため判定基準に含めず、揃った時に agent が行を足す。RevenueCat の課金指標と Firebase Analytics の利用指標は bannzai/dashboard が日次で集めており、`read-dashboard-metric.sh` で読める (MRR と D7 リテンションは 2026-10-27 に判定基準へ入れた)。ほかの指標 (アクティブなサブスクリプション数・paywall のファネル等) は、仮説の判定に要る時に agent が同じ計測元で行を足す。
