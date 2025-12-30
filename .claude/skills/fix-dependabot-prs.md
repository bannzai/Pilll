# Dependabot PRまとめ解決スキル

dependabotから上がってきた複数のPRを一括で解決し、まとめPRを作成します。

## 実行手順

### 1. dependabotのPR一覧を取得

```bash
gh pr list --author "app/dependabot" --state open
```

### 2. 各PRの状態を確認

各PRについて以下を確認する:
- PRの変更内容（`gh pr view <PR番号>`）
- GitHub ActionsのCI結果（`gh pr checks <PR番号>`）
- 差分内容（`gh pr diff <PR番号>`）

### 3. まとめブランチを作成

```bash
git checkout main
git pull origin main
git checkout -b fix/dependabot-updates-$(date +%Y%m%d)
```

### 4. 各PRの変更を取り込む

各dependabot PRのブランチから変更を取り込む:

```bash
# 例: dependabot/npm_and_yarn/パッケージ名-バージョン のようなブランチ名
git fetch origin <dependabotブランチ名>
git cherry-pick <コミットハッシュ>
# または
git merge origin/<dependabotブランチ名> --no-edit
```

### 5. 矛盾の解決

PR同士で矛盾する変更がある場合:
- 両方の変更を取り込むのが難しい場合は、片方を諦めてOK
- 諦めた理由と背景は、後でまとめPRにコメントとして記載する

### 6. コード生成の実行

dependabot PRはCIのcodegenステップで落ちていることが多いため、必ず実行する:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
dart format lib -l 150
```

変更があればコミット:

```bash
git add -A
git commit -m "chore: run build_runner after dependency updates"
```

### 7. iOS Podfile.lockの更新

iOSの依存関係も更新が必要な場合が多い:

```bash
cd ios
pod install --repo-update
cd ..
```

変更があればコミット:

```bash
git add ios/Podfile.lock
git commit -m "chore: update Podfile.lock"
```

### 8. ビルド・テストの確認

```bash
flutter analyze
flutter test
```

### 9. まとめPRを作成

```bash
git push origin HEAD
gh pr create --title "chore: dependabot PRまとめ更新" --body "$(cat <<'EOF'
## 概要
dependabotから上がってきた複数のPRをまとめて対応しました。

## 取り込んだPR
- #PR番号1: パッケージ名 x.x.x → y.y.y
- #PR番号2: パッケージ名 x.x.x → y.y.y
...

## 追加対応
- [ ] build_runner実行
- [ ] Podfile.lock更新

## 除外したPR（ある場合）
- #PR番号: 除外理由

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### 10. 除外したPRがある場合

まとめPRにコメントで理由を記載:

```bash
gh pr comment <まとめPR番号> --body "$(cat <<'EOF'
## 除外したdependabot PR

### #PR番号: パッケージ名の更新
**理由**: （例）他のパッケージとの依存関係が矛盾するため
**背景**: （詳細な説明）
**今後の対応**: （必要であれば）
EOF
)"
```

### 11. 元のdependabot PRをクローズ

まとめPRがマージされた後、元のdependabot PRをクローズする:

```bash
gh pr close <PR番号> --comment "まとめPR #<まとめPR番号> で対応しました"
```

## 注意点

- dependabotのPRは作成時点でCIが落ちていることが多いので、必ずCI結果を確認する
- Flutter/Dartプロジェクトでは`build_runner`の実行が必要なことが多い
- iOSビルドには`Podfile.lock`の更新が必要なことが多い
- 複数のパッケージ更新で依存関係が矛盾する場合は、無理に両方を取り込まず、片方を諦める判断も重要
- 諦めた場合は必ず理由を記録する
