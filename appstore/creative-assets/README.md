# Pilll の App Store Creative Asset (header / search results)

castle issue https://github.com/bannzai/castle/issues/1503 の「各リポジトリの対応」で 2026-10-07 に作成した。App Store Connect の Asset Library に入れた画像の生成元 (プロンプト) と、どこに配置したかを記録する。入稿済みの画像の実体は ASC の Asset Library (App ID 1405931017) にあり、リポジトリには生成元とプレビューだけを置く。

## 方針

- 画像内に文字を入れない (Apple は画像内テキストを対応する全言語でローカライズするよう求めるため。検索結果ではアプリ名とサブタイトルが画像の横に出る)
- 1 つの訴求 (1 つのアイデア) を、中央に小さく置いた 1 組のモチーフで表す (Apple の header の指針「単一の明確なアイデアに絞る」「視覚的に混雑させない」)
- 16:9 で 4K 生成した 1 枚から、header (21:9、3840x1646) と search results (3:2、3840x2560) を中央クロップで作る。被写体は両方の Art Safe Area の共通部分 (幅・高さの中央 40% 程度) に収める
- 避ける見た目は `~/.claude/documents/guides/visual-patterns-to-avoid.md` の「画像」の項目 (グラデーション・ツヤのある 3D・ネオン・金属・パステル・人物・既定の記号の寄せ集め)

## 画像と配置

| 訴求 (ディレクトリ) | 用途 | header の IMAGE_ID | search results の IMAGE_ID | 配置先 |
|---|---|---|---|---|
| reminder | CPP reminder-202607 (v2) と birthcontrol-202607 (v2)。既定の製品ページにも使う | e6400005-3ccc-8e09-8007-73bd14c0b80b | b5400005-3ccc-8e09-802f-db78b35874b5 | 配置 62 件 (ローカライズ x 種別) |
| privacy | CPP privacy-202607 (v2) | ae800005-3ccc-8e09-8038-07013440329d | cf000005-3ccc-8e09-800c-6b4c21552154 | 配置 62 件 (ローカライズ x 種別) |
| menstruation | CPP menstruation-202607 (v2) | 0fc00005-3ccc-8e09-8001-bb9b31a56f99 | f5800005-3ccc-8e09-8007-b899ee75da2a | 配置 62 件 (ローカライズ x 種別) |
| beginner | CPP beginner-202607 (v2) | 36400005-3ccc-8e09-8026-b5e36b55aff5 | 75400005-3ccc-8e09-8008-015684297ba4 | 配置 62 件 (ローカライズ x 種別) |

## 再生成と検証の手順

```sh
# 1. 生成 (gemini-image-generator skill。16:9 / 4K)
bash ~/.claude/skills/gemini-image-generator/scripts/generate_image.sh --prompt "$(cat appstore/creative-assets/<concept>/prompt.txt)" --output tmp/<concept>-16x9.png --aspect-ratio 16:9 --image-size 4K
# 2. 中央クロップ (appstore-header-creative skill)
bash ~/.claude/skills/appstore-header-creative/scripts/normalize_asset.sh tmp/<concept>-16x9.png tmp/<concept>-header.png --type header
bash ~/.claude/skills/appstore-header-creative/scripts/normalize_asset.sh tmp/<concept>-16x9.png tmp/<concept>-search.png --type search-results
# 3. 入稿前の検証 (フォーマット・サイズ・Art Safe Area の座標)
bash ~/.claude/skills/appstore-header-creative/scripts/check_header_asset.sh tmp/<concept>-header.png --type header
bash ~/.claude/skills/appstore-header-creative/scripts/check_header_asset.sh tmp/<concept>-search.png --type search-results
# 4. Asset Library へのアップロードと配置 (appstore-custom-product-page skill)
ASC_APP_ID=1405931017 bash ~/.claude/skills/appstore-custom-product-page/scripts/asset_library_upload_image.sh tmp/<concept>-header.png --reference-name "<app>-<concept>-<yyyymm>-header"
ASC_APP_ID=1405931017 bash ~/.claude/skills/appstore-custom-product-page/scripts/asset_library_set_placement.sh --target cpp|version --localization <LOCALIZATION_ID> --type header --image <IMAGE_ID>
```

2026-10-07 の検証結果: 上の全画像で `check_header_asset.sh` が header / search results ともに `[OK] フォーマット: png`・`[OK] サイズ` の 2 件 OK、WARN 0、NG 0。Art Safe Area 内に主役が収まることは生成画像を目視で確認した。

## 配置先の親の状態と提出の経路

公開前のバージョン (PREPARE_FOR_SUBMISSION) と新しい CPP バージョンには今すぐ配置でき、その提出に含まれる。公開中のバージョン・承認済みの CPP バージョンには、画像が APPROVED になるまで配置できない (ASC API が 409 `ENTITY_ERROR.RELATIONSHIP.INVALID` を返す。2026-10-07 実測)。その場合は `cpp_submit.sh --image <IMAGE_ID>` で画像を単体提出し、承認後に配置する。経路の表は `~/.claude/skills/appstore-header-creative/references/asset-spec.md`。
