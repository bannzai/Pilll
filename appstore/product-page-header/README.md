# Pilll の App Store ヘッダー

## 訴求とデザイン

「今日の服用を確認できる安心感」を、無地のピルシートとコーラル色の服用済みチェックで表現する。`fastlane/metadata/ja/name.txt`、`subtitle.txt`、`description.txt` のピル管理・飲み忘れの不安を安心に変える訴求を根拠とした。薬の用法・用量を示す図ではなく、服用記録の抽象的なイメージである。

配色は `lib/components/atoms/color.dart` の `primary`、`secondary`、`mat` を参照して選定した。生成時の具体的な色指定と構図は `prompt.txt` に保存している。文字と数字を使わず、全言語共通の素材とする。

## 仕様

入稿用ファイルは `header.jpg`。2026-09-09 に Apple 公式 Photoshop テンプレートを取得・解析し、キャンバス 3840×1646、Art Safe Area は left=1097、top=493、right=2743、bottom=1154 と確認した。

公式ガイド: https://developer.apple.com/app-store/asset-best-practices/

## 制作・検証

既存案はピルシートの上下がセーフエリアを越えていたため採用せず、主役を中央の横帯に小さく配置するプロンプトで新規生成した。指定の生成ラッパーを使用し、21:9・4K で出力した。

実行コマンド（リポジトリのルートで実行）:

```sh
bash ~/.agents/skills/appstore-header-creative/scripts/fetch_template_spec.sh --type header --cache-dir ./tmp/appstore-header-creative
bash ~/.agents/skills/appstore-header-creative/scripts/normalize_asset.sh tmp/header-raw.png tmp/header-normalized.png --type header
sips -s format jpeg tmp/header-normalized.png --out appstore/product-page-header/header.jpg
bash ~/.agents/skills/appstore-header-creative/scripts/check_header_asset.sh appstore/product-page-header/header.jpg --type header
bash ~/.agents/skills/pr-attach-screenshots/scripts/check-upload-target.sh appstore/product-page-header/header.jpg
```

すべて exit 0。最終ファイルの検証出力:

```text
[OK] フォーマット: jpeg
[OK] サイズ: 3840x1646
[INFO] Art Safe Area (実画像換算): left=1097 top=493 right=2743 bottom=1154 — キーコンテンツ・コピーはこの範囲内に収める
```

最終検証は OK 2件、WARN 0件、NG 0件。公開前の機械検査も `mime=image/jpeg` で合格。最終 JPG を表示し、ピルシート・チェック形状・粒子がすべてセーフエリア内に収まること、文字・数字・実在ロゴ・個人情報・秘匿情報・価格や受賞表示がないことを目視確認した。

生成は exit 0、6336×2688 で出力された。生成ライブラリから AFC 呼び出し方法の非推奨警告が出た。正規化時には `kern.hv_vmm_present` の取得失敗と、出力拡張子を JPG にすべきという警告が出たため、`sips` で JPEG 形式を明示して最終ファイルを書き出し、上記の検証を行った。拡大警告はなかった。

App Store Connect の入稿先確認・入稿・受理確認は依頼範囲外で未実施。アプリの実装変更がないため Flutter のテスト・ビルド・Maestro は実行対象外。

## セッション再開

```sh
cd /Users/bannzai/worktrees/bannzai/Pilll/appstore-header-creative
codex resume 01a08542-111d-7101-85d8-8d50b68a517f
```
