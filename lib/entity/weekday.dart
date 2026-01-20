// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// 曜日を表すenumクラス
///
/// Pilllアプリ内でカレンダー表示、ピル服用記録、生理記録などの
/// 日付関連機能において曜日を統一的に管理するために使用される。
/// 日曜日から土曜日までの7つの曜日を定義し、UI表示での色分けや
/// 週の開始曜日の設定などをサポートする。
enum Weekday {
  /// 日曜日
  /// UI表示では専用の日曜日カラー(AppColors.sunday)が適用される
  Sunday,

  /// 月曜日
  /// 平日として扱われ、AppColors.weekdayが適用される
  Monday,

  /// 火曜日
  /// 平日として扱われ、AppColors.weekdayが適用される
  Tuesday,

  /// 水曜日
  /// 平日として扱われ、AppColors.weekdayが適用される
  Wednesday,

  /// 木曜日
  /// 平日として扱われ、AppColors.weekdayが適用される
  Thursday,

  /// 金曜日
  /// 平日として扱われ、AppColors.weekdayが適用される
  Friday,

  /// 土曜日
  /// UI表示では専用の土曜日カラー(AppColors.saturday)が適用される
  Saturday,
}

/// Weekday enumに対する拡張メソッドを提供するextension
///
/// 日付からの曜日変換、週の開始曜日設定、文字列変換、色変換など
/// Pilllアプリで必要な曜日関連の操作を提供する。
extension WeekdayFunctions on Weekday {
  /// DateTimeオブジェクトから対応するWeekdayを取得する
  ///
  /// Dartの標準DateTime.weekdayは月曜日が1で始まるが、
  /// このメソッドは日曜日を0とするWeekday enumに適切に変換する。
  /// カレンダー表示や日付処理で広く使用される。
  static Weekday weekdayFromDate(DateTime date) {
    var weekdayIndex = date.weekday;
    var weekdays = Weekday.values;
    var sunday = weekdays.first;
    weekdays = weekdays.sublist(1)
      ..addAll(weekdays.sublist(0, weekdays.length))
      ..insert(0, sunday);
    return weekdays[weekdayIndex];
  }

  /// 指定した曜日を週の開始とする曜日順のリストを生成する
  ///
  /// カレンダー表示において、ユーザーの地域設定や好みに応じて
  /// 週の開始曜日を変更する際に使用される。
  /// 例：月曜日開始の場合、[月,火,水,木,金,土,日]の順で返される
  static List<Weekday> weekdaysForFirstWeekday(Weekday firstWeekday) {
    return Weekday.values.sublist(firstWeekday.index)
      ..addAll(Weekday.values.sublist(0, firstWeekday.index));
  }

  /// 曜日の短縮形文字列を取得する
  ///
  /// DateTimeFormatterを使用して現在のロケールに応じた
  /// 曜日の短縮表記（例：「日」「月」「火」など）を返す。
  /// カレンダーUIでの表示に使用される。
  // TODO: [Localizations]
  String weekdayString() {
    return DateTimeFormatter.shortWeekdays()[index];
  }

  /// 曜日に対応するカラーを取得する
  ///
  /// UI表示での曜日の色分けを提供する。
  /// 日曜日は赤系、土曜日は青系、平日は標準色で表示される。
  /// カレンダー表示やピル服用記録の日付表示で視覚的な区別に使用される。
  Color weekdayColor() {
    switch (this) {
      case Weekday.Sunday:
        return AppColors.sunday;
      case Weekday.Monday:
        return AppColors.weekday;
      case Weekday.Tuesday:
        return AppColors.weekday;
      case Weekday.Wednesday:
        return AppColors.weekday;
      case Weekday.Thursday:
        return AppColors.weekday;
      case Weekday.Friday:
        return AppColors.weekday;
      case Weekday.Saturday:
        return AppColors.saturday;
    }
  }
}
