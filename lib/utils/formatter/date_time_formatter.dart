import 'dart:io';

import 'package:intl/intl.dart';

/// 画面に表示する日付・時刻の文字列を作る。
/// 表示用のフォーマッタは locale を渡さず、[Intl.defaultLocale] (AppLocalizationResolver が画面の文言と同じ言語に設定する) の書式で返す。
/// [Platform.localeName] (端末の言語) を使うと、端末の言語とアプリの表示言語が異なる時に 1 つの画面に 2 つの言語が混ざるため
class DateTimeFormatter {
  static String militaryTime(DateTime dateTime) {
    var formatter = NumberFormat('00');
    return '${formatter.format(dateTime.hour)}:${formatter.format(dateTime.minute)}';
  }

  static String yearAndMonth(DateTime dateTime) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH).format(dateTime);
  }

  static String yearAndMonthAndDay(DateTime dateTime) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(dateTime);
  }

  static String jaMonth(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH).format(dateTime);
  }

  /// 曜日付きの月日を [Intl.defaultLocale] (画面の文言と同じ言語) の書式で返す。
  /// ja は数字の書式 (10/5(月))、ja 以外は月名の省略形の書式 (en: Mon, Oct 5 / es: lun, 5 oct) にする。
  /// ja 以外で数字の書式にすると es の「sáb, 16/1」のように月日の区別が付きにくいため月名にし、ja の表示は変えない
  static String monthAndWeekday(DateTime dateTime) {
    return DateFormat(
      Intl.shortLocale(Intl.getCurrentLocale()) == 'ja' ? DateFormat.NUM_MONTH_WEEKDAY_DAY : DateFormat.ABBR_MONTH_WEEKDAY_DAY,
    ).format(dateTime);
  }

  /// 月日を [Intl.defaultLocale] (画面の文言と同じ言語) の数字の書式で返す (ja・en: 10/29 / es: 29/10 / de: 29.10.)。
  /// ピルシートの日付表示モードの狭いセルでも使うため、月名にせず数字の書式のまま各言語の並び順にする
  static String monthAndDay(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH_DAY).format(dateTime);
  }

  // 2022/01/08
  static String slashYearAndMonthAndDay(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  // 2022/01/08 12:20
  static String slashYearAndMonthAndDayAndTime(DateTime dateTime) {
    final date = slashYearAndMonthAndDay(dateTime);
    final time = hourAndMinute(dateTime);
    return '$date $time';
  }

  // 2022/01
  static String slashYearAndMonth(DateTime dateTime) {
    return DateFormat('yyyy/MM').format(dateTime);
  }

  static String slashMonthAndDay(DateTime dateTime) {
    return DateFormat('MM/dd').format(dateTime);
  }

  /// Diary のドキュメント ID (`Diary_yyyyMMdd`) に使う文字列を返す。
  /// 表示用ではなく Firestore のドキュメント ID のため、表示言語に合わせない。
  /// locale によって数字の字形が変わる (fa・mr 等) ため、ここを変えると既存の日記のドキュメント ID と一致しなくなる
  static String diaryIdentifier(DateTime dateTime) {
    return DateFormat('yyyyMMdd', Platform.localeName).format(dateTime);
  }

  // 12:20
  static String hourAndMinute(DateTime dateTime) {
    final format = NumberFormat('00');
    return '${format.format(dateTime.hour)}:${format.format(dateTime.minute)}';
  }

  // 12:20:30
  static String clock(int hour, minute, second) {
    final format = NumberFormat('00');
    return '${format.format(hour)}:${format.format(minute)}:${format.format(second)}';
  }

  // 月火水木金土日
  static String shortWeekday(DateTime dateTime) {
    return DateFormat.E().format(dateTime);
  }

  // [日月火水木金土]
  static List<String> shortWeekdays() {
    return DateFormat.E().dateSymbols.SHORTWEEKDAYS;
  }
}
