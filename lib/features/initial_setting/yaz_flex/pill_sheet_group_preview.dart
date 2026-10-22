import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet.dart';

/// ヤーズフレックス向けの初期設定で、入力途中の内容から組み立てたピルシートグループを登録前に見せるプレビュー
/// 各ピルの番号は登録後のホームと同じ服用日数 (休薬明けに1に戻る) で、服用済みのピルはホームと同じ服用済みの表示にする
/// [markedPill] の位置のピルは、入力している値がどのピルを指すかを示す印 (選択中の色) にする。null の時は印を付けない
class YazFlexPillSheetGroupPreview extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final ({int pageIndex, int pillNumberInPillSheet})? markedPill;

  /// 最初に表示するピルシートの pageIndex。入力している値に関係するピルシートを開いた状態で見せる
  final int initialPageIndex;

  const YazFlexPillSheetGroupPreview({
    super.key,
    required this.pillSheetGroup,
    required this.markedPill,
    required this.initialPageIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // iPhone Duo の外側ディスプレイでは OS が画面右端の列を占有して SafeArea の右 inset になり、
    // MediaQuery の幅 (画面全体) より使える幅が狭い。画面幅ではなく PageView 自身の幅からページ幅を決める
    return LayoutBuilder(
      builder: (context, constraints) => HookBuilder(
        builder: (context) {
          final pageController = usePageController(
            initialPage: initialPageIndex,
            viewportFraction: (PillSheetViewLayout.width + 20) / constraints.maxWidth,
            keys: [constraints.maxWidth, initialPageIndex],
          );
          return Column(
            children: [
              SizedBox(
                height: PillSheetViewLayout.calcHeight(
                  PillSheetViewLayout.mostLargePillSheetType(pillSheetGroup.pillSheetTypes).numberOfLineInPillSheet,
                  true,
                ),
                child: PageView(
                  clipBehavior: Clip.none,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: pillSheetGroup.pillSheets.map((pillSheet) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PillSheetViewLayout(
                            weekdayLines: null,
                            pillMarkLines: List.generate(pillSheet.pillSheetType.numberOfLineInPillSheet, (lineIndex) {
                              return PillMarkLine(pillMarks: _pillMarks(pageIndex: pillSheet.groupIndex, lineIndex: lineIndex));
                            }),
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              if (pillSheetGroup.pillSheets.length > 1) ...[
                const SizedBox(height: 16),
                DotsIndicator(
                  controller: pageController,
                  itemCount: pillSheetGroup.pillSheets.length,
                  onDotTapped: (page) {
                    pageController.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  List<Widget> _pillMarks({required int pageIndex, required int lineIndex}) {
    final pillSheet = pillSheetGroup.pillSheets[pageIndex];
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length > pillSheet.pillSheetType.totalCount) {
      countOfPillMarksInLine = pillSheet.pillSheetType.totalCount - lineIndex * Weekday.values.length;
    }
    return List.generate(Weekday.values.length, (columnIndex) {
      if (columnIndex >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }

      final pillNumberInPillSheet = PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(columnIndex, lineIndex);
      final markedPill = this.markedPill;
      final pillMarkType = markedPill != null && markedPill.pageIndex == pageIndex && markedPill.pillNumberInPillSheet == pillNumberInPillSheet
          ? PillMarkType.selected
          : pillMarkFor(pillNumberInPillSheet: pillNumberInPillSheet, pillSheet: pillSheet);
      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          pillNumber: PlainPillNumber(
            text: pillSheetGroup.displayPillNumberWithoutDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
          ),
          pillMark: PillMark(
            showsRippleAnimation: false,
            showsCheckmark: pillMarkType == PillMarkType.done,
            pillMarkType: pillMarkType,
            remainingPillTakenCount: null,
          ),
          // プレビューなのでピルをタップしても何もしない
          onTap: () {},
        ),
      );
    });
  }
}
