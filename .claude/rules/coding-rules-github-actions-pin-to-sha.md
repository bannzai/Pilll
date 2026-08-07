---
paths:
  - ".github/workflows/*.{yml,yaml}"
  - "**/.github/workflows/*.{yml,yaml}"
---

# GitHub Actions の action は commit SHA で固定する

workflow の `uses:` はタグ参照（`@v4` 等）ではなく、フルレングスの commit SHA + バージョンコメントで固定する。タグは可変で、action リポジトリが侵害されるとタグごと悪性コードに差し替えられるため（GitHub 公式推奨の hardening）。

- 記法: `uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 # v4.3.1`
- SHA の調べ方: `git ls-remote https://github.com/<owner>/<repo>.git 'refs/tags/v*'` でタグと SHA の一覧を取得し、`gh api repos/<owner>/<repo>/git/ref/tags/<tag> --jq '.object.type + " " + .object.sha'` でオブジェクト型を確認する。`commit`（lightweight tag）ならその SHA をそのまま使える。`tag`（annotated tag）なら `gh api repos/<owner>/<repo>/git/tags/<tag SHA>` で 1 段 deref して commit SHA を得る
- コメントに書くバージョンは「メジャータグが現時点で指す実バージョン」にする。最新リリースがメジャータグより進んでいることがある（実例: tailscale/github-action は v4.1.3 が最新だったが v4 タグは v4.1.2 を指していた）。挙動を変えないため、メジャータグが指す SHA に固定する
- サブディレクトリ action（`actions/cache/restore` 等）の SHA は親リポジトリ（actions/cache）のタグから取る
- 変更後は該当 workflow を 1 回実行して動作確認する

参照: https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions
実例: https://github.com/bannzai/simtunnel/pull/9
