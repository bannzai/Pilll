import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット用 Mock 画面で共有する部品と描画ヘルパー。
///
/// アイコン類は Material Icons を使わない。flutter test 環境では MaterialIcons
/// フォントが解決されず豆腐になるため、記号は自前描画する（本番 SVG を使うタブバー等を除く）。

/// スクショ用に [todayRepository] を固定日時へ差し替え、intl の日付整形データを初期化する。
///
/// RecordPagePillSheet 等の本番コンポーネントは内部で `today()`/`now()`（lib/utils/datetime/day.dart）
/// を参照するため、テストと同じ方式（`todayRepository = ...`）で固定する。また本番の
/// DateTimeFormatter は `Platform.localeName`（Simulator のシステムロケール）で intl の DateFormat を
/// 使うため、entrypoint() を通さないカタログでは未初期化のままだと LocaleDataException になる。
/// そのため呼び出し時に毎回 initializeDateFormatting しておく（同じロケールへの再初期化は無害）。
///
/// 呼び出しは冪等（同じ [fixedDate] を渡す限り、todayRepository は同じ状態になる）。
void applyFixedToday(DateTime fixedDate) {
  todayRepository = _FixedTodayService(fixedDate);
  initializeDateFormatting(Platform.localeName);
}

/// [applyFixedToday] が使う固定日時版の [TodayService]。
class _FixedTodayService extends TodayService {
  _FixedTodayService(this.fixedDate);

  /// `now()` が常に返す固定日時。
  final DateTime fixedDate;

  @override
  DateTime now() => fixedDate;
}

/// 通知バナーに表示する実際の Pilll アプリアイコン。
class PilllAppIcon extends StatelessWidget {
  const PilllAppIcon({super.key, required this.size});

  /// アイコンの一辺の長さ。
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.24),
      child: Image.asset(
        'images/pilll_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

/// ピル錠を模した傾いたカプセル。タブアイコンに使う。
class PillCapsule extends StatelessWidget {
  const PillCapsule({super.key, required this.width, required this.height, required this.color});

  /// カプセルの長辺。
  final double width;

  /// カプセルの短辺。
  final double height;

  /// カプセルの色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.7,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
      ),
    );
  }
}

/// リマインド通知の見本本文（固定サンプル：7/18・16番）。
///
/// 実装の本文生成（lib/utils/local_notification.dart の
/// `RegisterReminderLocalNotification.run` 内、`premiumOrTrial` 分岐のタイトル組み立て：
/// `${word} ${month}/${day} (${weekday}) ${pillNumber}${L.number}`、
/// デフォルト word は [pillEmoji]）に合わせた文言。DateTimeFormatter/L.number は
/// `Platform.localeName`（Simulator のシステムロケール）と [L] を使うため、全撮影言語で
/// 本番と同じ日付・曜日・番号単位になる。
String reminderNotificationSampleBody() {
  final date = DateTime(2026, 7, 18);
  return '💊 ${DateTimeFormatter.monthAndDay(date)} (${DateTimeFormatter.shortWeekday(date)}) 16${L.number}';
}

/// iOS の通知バナーを模したカード。
///
/// アプリアイコン・アプリ名・時刻・本文を並べる。ロック画面・ホーム画面いずれでも使う。
/// 実機の iOS 通知に合わせ、アプリ名は 1 行だけ（上段）、その下に本文を置く。
class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    super.key,
    required this.message,
    required this.time,
    this.opacity = 0.96,
    this.showCheck = false,
  });

  /// アプリ名の下に太字で出す本文。
  final String message;

  /// 右上に出す時刻表記（"今" / "9:41" 等）。
  final String time;

  /// カード背景の不透明度。ロック画面では磨りガラス風に下げる。
  final double opacity;

  /// 右端に緑のチェック丸を出すか。服用済みの確認バナーに使う。
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PilllAppIcon(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Pilll', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TextColor.gray)),
                    const Spacer(),
                    Text(time, style: const TextStyle(fontSize: 12, color: TextColor.gray)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(message, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: TextColor.main)),
              ],
            ),
          ),
          if (showCheck) ...[
            const SizedBox(width: 12),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
              child: const Center(child: CustomPaint(size: Size(14, 11), painter: CheckPainter(color: Colors.white, strokeWidth: 2.2))),
            ),
          ],
        ],
      ),
    );
  }
}

/// チェックマーク（レ点）を描く。服用済みマーク・完了表示に使う。
class CheckPainter extends CustomPainter {
  const CheckPainter({required this.color, this.strokeWidth = 1.8});

  /// レ点の色。
  final Color color;

  /// レ点の線幅。
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.1, size.height * 0.55)
        ..lineTo(size.width * 0.4, size.height * 0.9)
        ..lineTo(size.width * 0.95, size.height * 0.1),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) => oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// 本番のホーム画面（home/page.dart の HomePageBody）が組む 4 タブのボトムバーをそのまま流用する。
///
/// home/page.dart 側はこの TabBar を独立コンポーネントとして切り出しておらず HomePageBody.build に
/// インライン記述されているため、ここでは同じアセットパス（images/tab_icon_*.svg 等）・ラベル（[L]）・
/// 配色（labelColor 等）で同じ構成を再現する。自作 CustomPainter によるアイコン描画はしない。
/// TabBar は表示用（タップ操作はしない）なので、ダミーの DefaultTabController で包むだけで良い。
class MockBottomTabBar extends StatelessWidget {
  const MockBottomTabBar({super.key, required this.activeIndex});

  /// 選択中タブのインデックス（0:記録 1:生理 2:カレンダー 3:設定）。home/page.dart の
  /// HomePageTabType の並び順と揃える。
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: activeIndex,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bottomBar,
          border: Border(top: BorderSide(width: 1, color: AppColors.border)),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 18),
        child: TabBar(
          labelColor: AppColors.primary,
          labelStyle: const TextStyle(fontSize: 12),
          indicatorColor: Colors.transparent,
          unselectedLabelColor: TextColor.gray,
          tabs: <Tab>[
            Tab(text: L.pill, icon: SvgPicture.asset(activeIndex == 0 ? 'images/tab_icon_pill_enable.svg' : 'images/tab_icon_pill_disable.svg')),
            Tab(text: L.menstruation, icon: SvgPicture.asset(activeIndex == 1 ? 'images/menstruation.svg' : 'images/menstruation_disable.svg')),
            Tab(
              text: L.calendar,
              icon: SvgPicture.asset(activeIndex == 2 ? 'images/tab_icon_calendar_enable.svg' : 'images/tab_icon_calendar_disable.svg'),
            ),
            Tab(
              text: L.settings,
              icon: SvgPicture.asset(activeIndex == 3 ? 'images/tab_icon_setting_enable.svg' : 'images/tab_icon_setting_disable.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ハートを描く。生理・お気に入りの表現に使う。
class HeartPainter extends CustomPainter {
  const HeartPainter({required this.color});

  /// ハートの塗り色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.95)
        ..cubicTo(size.width * -0.15, size.height * 0.5, size.width * 0.2, size.height * 0.0, size.width * 0.5, size.height * 0.32)
        ..cubicTo(size.width * 1.15, size.height * 0.0, size.width * 0.8, size.height * 0.5, size.width * 0.5, size.height * 0.95)
        ..close(),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(HeartPainter oldDelegate) => oldDelegate.color != color;
}

/// 服用履歴（takenPill）の固定データを [count] 日分、[fixedToday] から遡って生成する。
/// カレンダー(#6)と服用履歴(#7)の Mock が同じ履歴を表示するために共有する。
///
/// 各履歴は「その日の服用番号まで飲んだ」before/after の [PillSheetGroup] を持ち、
/// 本番の履歴行（PillSheetModifiedHistoryTakenPillAction）が服用番号・時刻を
/// 実データと同じ導出経路で表示できるようにする。
/// 服用番号は MockRecordScreen と同じ「今日=16番・28錠タイプ」に合わせる。
List<PillSheetModifiedHistory> mockTakenPillHistories({required DateTime fixedToday, required int count}) {
  const todayPillNumber = 16;
  // 服用時刻。先頭(今日)はアップル慣例の 9:41、過去日は夜の服用でばらつかせて実データらしくする。
  const takenTimes = [(9, 41), (21, 52), (22, 3), (21, 48), (22, 15), (21, 30), (21, 58)];
  final beginDate = fixedToday.subtract(const Duration(days: todayPillNumber - 1));

  PillSheetGroup groupWith({required DateTime lastTakenDate}) {
    final pillSheetID = firestoreIDGenerator();
    return PillSheetGroup(
      pillSheets: [
        PillSheet.v1(
          id: pillSheetID,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: beginDate,
          lastTakenDate: lastTakenDate,
          createdAt: fixedToday,
        ),
      ],
      createdAt: fixedToday,
      pillSheetIDs: [pillSheetID],
      // 履歴行に「N番」の番号表記を出すため番号モードにする。
      pillSheetAppearanceMode: PillSheetAppearanceMode.number,
    );
  }

  return List.generate(count, (index) {
    final day = fixedToday.subtract(Duration(days: index));
    final takenTime = takenTimes[index % takenTimes.length];
    final takenDateTime = DateTime(day.year, day.month, day.day, takenTime.$1, takenTime.$2);
    return PillSheetModifiedHistory(
      id: firestoreIDGenerator(),
      actionType: PillSheetModifiedActionType.takenPill.name,
      value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue(isQuickRecord: false)),
      beforePillSheetGroup: groupWith(lastTakenDate: day.subtract(const Duration(days: 1))),
      afterPillSheetGroup: groupWith(lastTakenDate: day),
      estimatedEventCausingDate: takenDateTime,
      createdAt: takenDateTime,
    );
  });
}
