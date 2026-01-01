#!/bin/bash

# Entity テスト追加スクリプト
# 各テストプラン markdown ファイルに対して Claude を実行し、テストを追加する

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# テストプランファイル一覧
PLAN_FILES=(
    "Add_test_plan_PillSheet.md"
    "Add_test_plan_PillSheetGroup.md"
    "Add_test_plan_Menstruation.md"
    "Add_test_plan_PillSheetModifiedHistory.md"
)

# 共通プロンプト
BASE_PROMPT='以下のテストプラン markdown ファイルに記載されているテストケースを実装してください。

## 注意事項
- テストファイルが存在しない場合は新規作成してください
- 既存のテストファイルがある場合は、既存のテストを壊さないように追加してください
- group内では `#getter名` または `#method名` の形式で命名してください
- テストケースは日本語で記述してください
- now()/today() のモックには MockTodayService を使用してください
- テストを追加したら `flutter test` で実行して確認してください
- 例外処理のテストを優先的に追加してください

## テストプランファイル
'

# 各プランファイルに対して Claude を実行
for plan_file in "${PLAN_FILES[@]}"; do
    echo "========================================"
    echo "Processing: $plan_file"
    echo "========================================"

    plan_path="$SCRIPT_DIR/$plan_file"

    if [[ ! -f "$plan_path" ]]; then
        echo "Error: Plan file not found: $plan_path"
        continue
    fi

    # プロンプトを構築
    prompt="${BASE_PROMPT}${plan_path}"

    # Claude を実行
    cd "$PROJECT_DIR"
    claude -p "$prompt" --add-dir . --permission-mode acceptEdits --max-turns 1000

    echo ""
    echo "Completed: $plan_file"
    echo ""
done

echo "========================================"
echo "All test plans processed!"
echo "========================================"
