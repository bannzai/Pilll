---
name: flutter-pub-update
description: Flutterプロジェクトのpubspec.yamlパッケージを更新するスキル。一括更新または指定パッケージ更新に対応。メジャーバージョン更新時は確認を挟み、更新前にpub.dev/GitHubでchangelogを確認して変更内容を報告する。$ARGUMENTSにパッケージ名を指定するか、--allで全パッケージ更新。
---

# Flutter Pub Update

## Overview

Flutterプロジェクトのpubspec.yaml依存パッケージを安全に更新するためのスキル。更新前に変更内容を確認し、メジャーバージョン変更時はユーザー確認を挟む。

## 使用方法

- `/flutter-pub-update パッケージ名` - 指定パッケージを更新
- `/flutter-pub-update パッケージ1 パッケージ2` - 複数パッケージを更新
- `/flutter-pub-update --all` - 全パッケージを一括更新

## ワークフロー

### Step 1: 現在の状態を確認

```bash
flutter pub outdated
```

出力から以下を把握:
- Current: 現在のバージョン
- Upgradable: pubspec.yaml制約内で更新可能なバージョン
- Resolvable: 制約を変更すれば更新可能なバージョン
- Latest: 最新バージョン

### Step 2: 更新対象の特定

**指定パッケージの場合**: $ARGUMENTSで指定されたパッケージのみ対象

**--allの場合**: outdatedで表示された全パッケージを対象

### Step 3: 各パッケージの更新差分を調査

対象パッケージごとにWebFetchツールを使用して変更内容を確認:

1. **pub.devのChangelogを確認**
   - URL: `https://pub.dev/packages/{パッケージ名}/changelog`
   - 現在バージョンから更新後バージョンまでの変更点を抽出

2. **GitHubリリースノートを確認**（必要に応じて）
   - pub.devのパッケージページからリポジトリURLを取得
   - リリースノートで詳細な変更内容を確認

3. **変更内容をまとめて報告**
   - 新機能
   - バグ修正
   - Breaking Changes（重要）
   - 非推奨になった機能

### Step 4: メジャーバージョン更新の確認

メジャーバージョンが変わる場合（例: 1.x.x → 2.x.x）:

1. Breaking Changesを明確に提示
2. 影響を受ける可能性のあるコードを説明
3. AskUserQuestionツールで更新の承認を確認

```
このパッケージはメジャーバージョンが変わります:
- {パッケージ名}: {現在バージョン} → {新バージョン}

Breaking Changes:
- [変更内容1]
- [変更内容2]

更新を続行しますか？
```

### Step 5: パッケージの更新

承認後、`flutter pub upgrade`コマンドを使用:

**指定パッケージの更新:**
```bash
flutter pub upgrade パッケージ名
```

**メジャーバージョンを含む更新:**
```bash
flutter pub upgrade --major-versions パッケージ名
```

**全パッケージの更新:**
```bash
flutter pub upgrade
```

**全パッケージのメジャーバージョン更新:**
```bash
flutter pub upgrade --major-versions
```

### Step 6: 更新結果の報告

更新完了後、以下を報告:

```
## 更新完了

| パッケージ | 旧バージョン | 新バージョン | 変更種別 |
|-----------|-------------|-------------|---------|
| xxx       | 1.0.0       | 1.2.0       | Minor   |
| yyy       | 2.0.0       | 3.0.0       | Major   |

### 主な変更点
- xxx: 新機能Aが追加
- yyy: APIが変更（要確認）
```

## 注意事項

- 自動生成ファイル（*.g.dart, *.freezed.dart）がある場合は`flutter pub run build_runner build --delete-conflicting-outputs`の実行を提案
