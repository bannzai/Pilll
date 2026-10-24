# Maestro E2E を GitHub Actions で回す

`.maestro/flows/` 配下の Maestro flow は、simtunnel (`simulator-session.yml`) の remote Simulator に対してローカルから実行できない (Maestro のドライバと WebDriverAgent が同じ XCUITest runner を使うため)。agent が PR の検証で E2E を回す時は、`.github/workflows/maestro-e2e.yml` を `workflow_dispatch` で起動し、GitHub Actions の macOS Runner 上でビルドから flow 実行までを行う。

workflow と `.github/scripts/maestro-e2e-run.sh` は maestro-e2e-actions skill (`~/.claude/skills/maestro-e2e-actions/SKILL.md`) の `setup-workflow.sh` で生成したもので、Pilll 固有の追加は workflow 側にだけ入れている (dev 環境の secret 復元と `--dart-define-from-file`、Simulator の日本語ロケール化)。

## 起動する

```sh
# ブランチ上の flow を回す (workflow は main にある版ではなく --ref のブランチの版が動く)
gh workflow run maestro-e2e.yml --ref <ブランチ> -f flows=.maestro/flows/feature_appeal
# 1 本だけ回す
gh workflow run maestro-e2e.yml --ref <ブランチ> -f flows=.maestro/flows/feature_appeal/feature_appeal_bar_shows.yaml
```

skill のスクリプトを使うと、dispatch した run の id と URL が出力される。

```sh
bash ~/.claude/skills/maestro-e2e-actions/scripts/run-e2e.sh --repo bannzai/Pilll --flows .maestro/flows/feature_appeal --ref <ブランチ>
```

input:

- `flows`: `all` か `.maestro/` 配下のコミット済みパス (ファイルかディレクトリ)。`all` で回る flow は `.maestro/flows/config.yaml` の `flows` が決める。E2E の flow を新しいディレクトリに足した時はそこにも足す。`..`・絶対パス・`.maestro/` 外・存在しないパスは runner 側 (`maestro-e2e-run.sh`) で拒否される。push していない flow は runner に無いため、先に push する
- `device`: Simulator のデバイス名 (既定 `iPhone 17`)
- `record_video`: 画面録画を artifact に含めるか (既定 `true`)

## 結果を取る

```sh
bash ~/.claude/skills/maestro-e2e-actions/scripts/collect-results.sh <RUN_ID> --repo bannzai/Pilll
```

run が完了していれば artifact `maestro-e2e-artifacts` をダウンロードし、展開先を表示する。未完了なら状態だけ表示するので、完了後に同じコマンドを実行する。

- `report.xml`: JUnit 形式の結果。flow ごとの成否と failure の内容
- `debug/`: Maestro の debug 出力 (失敗時のスクリーンショット・コマンドログ)
- `session.mp4`: 実行中の画面録画

build job で失敗した時は `maestro-e2e-artifacts` が出ないため、`gh run view <RUN_ID> --log-failed` でビルドログを見る。結果は run の URL と合わせて PR body に書く。

## 注意

- public repo のため、Actions のログと artifact (録画を含む) は誰でも見られる。flow はシード済みのダミーデータで完結させ、個人情報・未公開の情報を画面に出さない
- runner の Simulator は workflow で日本語ロケールにしている。flow は日本語の文言 (「次へ」等) で要素を指定してよい
