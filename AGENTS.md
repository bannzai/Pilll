# Claude Code Development

## Project Context

### Paths
- Commands: `.claude/commands/`
- Skills: `.claude/skills/`

## Development Guidelines
- Think in English, but generate responses in Japanese (思考は英語、回答の生成は日本語で行うように)

## issue の読み書き先
このリポジトリ (bannzai/Pilll) は public で issue 機能が無効。issue は private の bannzai/PilllBackend で管理している。

- 指示・skill に登場する issue のやりとり（作成・閲覧・コメント・ラベル操作など）は、すべて bannzai/PilllBackend の issue を読み書きする
- `gh issue` 系コマンドは必ず `--repo bannzai/PilllBackend` を指定する

<!-- ai-review-config begin -->
<!--
このブロックは自動生成です。直接編集せず、テンプレートを更新してから再生成してください。
内容は AI コードレビュー時の挙動指示であり、コードベース自体への規約ではありません。
-->

## レビュー時の応答スタイル

- 応答は日本語で行う

## レビュー範囲外

以下は自動レビューで指摘しない (別の検出経路があるため):

- コンパイルエラー・型エラー (ローカル/CI のビルドで検出される)
- Lint/フォーマット違反 (リンター・フォーマッターで検出される)
<!-- ai-review-config end -->
