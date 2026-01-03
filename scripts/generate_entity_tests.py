#!/usr/bin/env python3
"""
Entity テスト追加スクリプト
各Entity x {getter,method} ごとにClaude Codeでテストを追加し、PRを作成する

使用方法:
  python3 scripts/generate_entity_tests.py
  python3 scripts/generate_entity_tests.py --start-from PillSheet:todayPillNumber
  python3 scripts/generate_entity_tests.py -n 3  # 最初の3件のみ実行
  python3 scripts/generate_entity_tests.py --list  # 対象一覧を表示
"""

import argparse
import subprocess
import sys

ENTITY_METHODS: dict[str, list[str]] = {
    "PillSheet": [
        # Getters
        "documentID", "sheetType", "pillSheetType", "todayPillNumber",
        "lastTakenOrZeroPillNumber", "lastTakenPillNumber", "todayPillIsAlreadyTaken",
        "isTakenAll", "isBegan", "inNotTakenDuration", "pillSheetHasRestOrFakeDuration",
        "isActive", "estimatedEndTakenDate", "activeRestDuration", "dates",
        # Methods
        "isActiveFor", "displayPillTakeDate", "pillNumberFor", "buildDates",
    ],
    "PillSheetGroup": [
        # Getters
        "activePillSheet", "isDeactived", "sequentialTodayPillNumber",
        "sequentialLastTakenPillNumber", "sequentialEstimatedEndPillNumber",
        "lastTakenPillSheetOrFirstPillSheet", "lastTakenPillNumberWithoutDate",
        "pillSheetTypes", "restDurations", "pillNumbersInPillSheet", "pillNumbersForCyclicSequential",
        # Methods
        "activePillSheetWhen", "replaced",
        # Extension: PillSheetGroupPillSheetModifiedHistoryDomain
        "pillNumberWithoutDateOrZeroFromDate", "pillNumberWithoutDateOrZero",
        # Extension: PillSheetGroupDisplayDomain
        "displayPillNumberWithoutDate", "displayPillNumberOrDate",
        "displayPillSheetDate", "cycleSequentialPillSheetNumber",
        # Extension: PillSheetGroupPillNumberDomain
        "pillMark", "pillMarks",
        # Extension: PillSheetGroupMenstruationDomain
        "menstruationDateRanges",
        # Extension: PillSheetGroupRestDurationDomain
        "lastActiveRestDuration", "targetBeginRestDurationPillSheet", "availableRestDurationBeginDate",
    ],
    "Menstruation": [
        "documentID", "dateRange", "dateTimeRange", "isActive", "menstruationsDiff",
    ],
    "PillSheetModifiedHistory": [
        # Getters
        "enumActionType", "beforeActivePillSheet", "afterActivePillSheet",
        # Functions
        "missedPillDays",
        # Factory methods
        "createTakenPillAction", "createRevertTakenPillAction", "createCreatedPillSheetAction",
        "createChangedPillNumberAction", "createDeletedPillSheetAction",
        "createBeganRestDurationAction", "createEndedRestDurationAction",
        "createChangedRestDurationBeginDateAction", "createChangedRestDurationAction",
        "createChangedBeginDisplayNumberAction", "createChangedEndDisplayNumberAction",
    ],
}

ENTITY_FILE_MAP: dict[str, str] = {
    "PillSheet": "pill_sheet",
    "PillSheetGroup": "pill_sheet_group",
    "Menstruation": "menstruation",
    "PillSheetModifiedHistory": "pill_sheet_modified_history",
}

PROMPT_TEMPLATE = '''以下の指示に従って {entity} に関する {method} に関するテストケースの追加・編集・削除 を行なってください。

#### 各 getter や method についてのテストを書いていきたい
- そもそも使われてないgetter, methodは削除してください
- 分岐がない・計算が単純すぎる・テストを追加する意味がない物はスキップしましょう
- getter,method についてテストがないものについては追加で group("#{method}") を追加してその中でテストケースを書いていってください
- getter,method についてテストがあるものでもケース不十分のものについてはケースを追加していってください
- 例外をthrowするものに関してはその種類までチェックする必要はありません。例外が起きたかどうかをチェック。また、なぜその例外が必要かがコード上に明記がない場合は明記するようにしてください

#### 注意点
ケース不十分である判断として以下を確認すると良いでしょう。これを group {{ for value in values {{ group("{{value}} によるテスト) {{ switch (value) {{ case .case: test("{{value}}の場合のテスト" {{  except() }}  }}  のように for で囲んでも良いです。またenumが絡んでくる場合は switch でかくことで網羅性も担保できます。コンパイラの性質と一目でどういうテストがわかるかのバランスを取って記述してください。ここではPillSheetGroup,PillSheetについて深く言及していますが、それは他のEntityや機能に深く関わっておりこのEntityが一番複雑だからです

1. PillSheetAppearanceMode の設定値によって変化するものか
2. PillSheetType の内容により、ピルシートのピルの錠数、すべて実錠/偽薬期間/休薬期間 の有無・長さの違い などが変わります。これに限っては for value in PillSheetType.values のようにテストを書くのはやめましょう。必要なものは個別で静的にgroup,testを作るようにしてください
3. RestDuration の有無により ピルシートの表示される番号・日付が変化されたりします
4. PillSheetGroupDisplayNumberSetting の有無によりピルシート上に表示される開始と終了の番号が変化します
5. PIllSheetGroupが保持しているPillSheet間の境界の値は優先度高くチェック(1枚目の最後の番号と2枚目の開始の番号のチェック,2枚目の終了の番号と3枚目の開始の番号のチェック...など。続く)
6. now() によってPillSheetGroupが表現する「どこまで服用したか、今日服用するのはどれか」といった情報が変化されます。これを念頭にテストを書く。必要であればnowをモックしてテストケースを作成する

## 動作確認
git操作・gh pr create を行うまえにフォーマットを整えて単体テストを実行してください

- dart fix --apply lib && dart format lib -l 150
- flutter test test/entity/{entity_file}_test.dart"

#### Git操作
テスト追加・修正が完了したら、以下のコマンドを実行してください:
0. 変更点がない場合は何もしない
1. git add -A
2. git commit -m "test({entity}): add tests for {method}"
3. git push -u origin HEAD
4. gh pr create --base {base_branch} --title "test({entity}): add tests for {method}" --body "## Summary
- {entity} の {method} に関するテストを追加/修正

'''


def sanitize_branch_name(name: str) -> str:
    """ブランチ名に使えない文字を置換"""
    return name.replace("(", "_").replace(")", "_")


def run_command(cmd: list[str], check: bool = False) -> int:
    """コマンドを実行"""
    print(f"実行中: {' '.join(cmd)}")
    result = subprocess.run(cmd)
    if check and result.returncode != 0:
        print(f"コマンドが失敗しました: {' '.join(cmd)}")
        sys.exit(1)
    return result.returncode


def has_git_changes() -> bool:
    """git statusで変更があるかチェック（untracked含む）"""
    result = subprocess.run(
        ["git", "status", "--porcelain"],
        capture_output=True,
        text=True
    )
    return bool(result.stdout.strip())


def has_unpushed_commits(base_branch: str) -> bool:
    """ベースブランチと比較してコミットがあるかチェック"""
    result = subprocess.run(
        ["git", "log", f"{base_branch}..HEAD", "--oneline"],
        capture_output=True,
        text=True
    )
    return bool(result.stdout.strip())


def get_all_targets() -> list[tuple[str, str]]:
    """全ての (Entity, method) ペアを順序通りに返す"""
    targets = []
    for entity, methods in ENTITY_METHODS.items():
        for method in methods:
            targets.append((entity, method))
    return targets


def find_start_index(targets: list[tuple[str, str]], start_from: str) -> int:
    """--start-from で指定された位置のインデックスを返す"""
    entity, method = start_from.split(":")
    for i, (e, m) in enumerate(targets):
        if e == entity and m == method:
            return i
    raise ValueError(f"指定された開始位置が見つかりません: {start_from}")


def get_previous_branch(targets: list[tuple[str, str]], index: int) -> str:
    """指定インデックスの1つ前のブランチ名を返す"""
    if index == 0:
        return "add/test-logic-3"
    prev_entity, prev_method = targets[index - 1]
    return f"add/test-3/{prev_entity}-{sanitize_branch_name(prev_method)}"


def generate_prompt(entity: str, method: str, entity_file: str, base_branch: str) -> str:
    """プロンプトを生成"""
    return PROMPT_TEMPLATE.format(
        entity=entity,
        method=method,
        entity_file=entity_file,
        base_branch=base_branch,
    )


def main():
    parser = argparse.ArgumentParser(description="Entity テスト追加スクリプト")
    parser.add_argument("--start-from", type=str, help="開始位置 (例: PillSheet:todayPillNumber)")
    parser.add_argument("-n", "--num", type=int, help="実行する件数を制限 (例: -n 3)")
    parser.add_argument("--list", action="store_true", help="対象一覧を表示")
    parser.add_argument("--dry-run", action="store_true", help="実際のコマンドを実行せずにプロンプトを表示")
    args = parser.parse_args()

    targets = get_all_targets()

    if args.list:
        print(f"対象一覧 (合計: {len(targets)}件)")
        print("=" * 60)
        for i, (entity, method) in enumerate(targets):
            print(f"{i+1:3}. {entity}:{method}")
        return

    start_index = 0
    if args.start_from:
        start_index = find_start_index(targets, args.start_from)
        print(f"開始位置: {args.start_from} (インデックス: {start_index})")

    # 終了インデックスを計算
    end_index = len(targets)
    if args.num:
        end_index = min(start_index + args.num, len(targets))
        print(f"実行件数: {args.num}件 (インデックス {start_index} から {end_index - 1} まで)")

    base_branch = get_previous_branch(targets, start_index) 
    # base_branch = "add/test-logic-3"

    for i in range(start_index, end_index):
        entity, method = targets[i]
        entity_file = ENTITY_FILE_MAP[entity]
        branch_name = f"add/test-3/{entity}-{sanitize_branch_name(method)}"

        print(f"\n{'='*60}")
        print(f"処理中: {entity}:{method} ({i+1}/{len(targets)})")
        print(f"ブランチ: {branch_name}")
        print(f"ベース: {base_branch}")
        print(f"{'='*60}\n")

        prompt = generate_prompt(entity, method, entity_file, base_branch)

        if args.dry_run:
            print("--- プロンプト ---")
            print(prompt)
            print("--- プロンプト終了 ---\n")
            base_branch = branch_name
            continue

        # 1. ベースブランチにチェックアウト
        run_command(["git", "checkout", base_branch], check=True)

        # 2. 新しいブランチを作成
        run_command(["git", "switch", "-c", branch_name], check=True)

        # 3. Claude Code 実行
        run_command([
            "claude", "-p", prompt,
            "--add-dir", ".",
            "--permission-mode", "acceptEdits",
            "--max-turns", "1000"
        ])

        # 4. 変更があるかチェック
        if has_git_changes() or has_unpushed_commits(base_branch):
            # 変更がある場合: ベースブランチを更新（次のPR用）
            print(f"\n変更あり: {branch_name} を次のベースブランチとして使用")
            base_branch = branch_name
        else:
            # 変更がない場合: ブランチを破棄して元のブランチに戻す
            print(f"\n変更なし: {branch_name} を破棄して {base_branch} に戻ります")
            run_command(["git", "checkout", base_branch])
            run_command(["git", "branch", "-D", branch_name])
            # base_branchは更新しない（次のイテレーションでも同じベースを使う）

    print("\n" + "=" * 60)
    print("全ての処理が完了しました")
    print("=" * 60)


if __name__ == "__main__":
    main()
