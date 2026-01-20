import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/localizations/l.dart';

/// ピルシートの種類を定義するenum。
/// 実薬と偽薬・休薬の組み合わせにより、異なるピルシートタイプを表現する。
/// Firestoreの'pill_sheet_types'コレクションで使用される。
/// 各タイプは錠数と休薬・偽薬の日数により区別される。
/// UI表示用の画像リソースと紐づいている。
enum PillSheetType {
  /// 21錠の実薬と7日間の休薬期間を持つピルシートタイプ
  // "21錠+休薬7日";
  pillsheet_21,

  /// 24錠の実薬と4錠の偽薬を持つ28錠ピルシートタイプ
  // "24錠+4日偽薬";
  pillsheet_28_4,

  /// 21錠の実薬と7錠の偽薬を持つ28錠ピルシートタイプ
  // "21錠+7日偽薬";
  pillsheet_28_7,

  /// 28錠すべてが実薬のピルシートタイプ
  // "28錠タイプ(すべて実薬)";
  pillsheet_28_0,

  /// 24錠すべてが実薬のピルシートタイプ
  // "24錠タイプ(すべて実薬)";
  pillsheet_24_0,

  /// 21錠すべてが実薬のピルシートタイプ
  // "21錠タイプ(すべて実薬)";
  pillsheet_21_0,

  /// 24錠の実薬と4日間の休薬期間を持つピルシートタイプ
  // "24錠+4日休薬";
  // ignore: constant_identifier_names
  pillsheet_24_rest_4,
}

/// PillSheetTypeに機能を拡張するextension。
/// Firestore操作、UI表示、ビジネスロジック計算のメソッドを提供する。
/// 各ピルシートタイプの特性値（錠数、服用期間など）を計算する。
extension PillSheetTypeFunctions on PillSheetType {
  /// Firestoreの'pill_sheet_types'コレクションのパス定数
  static const String firestoreCollectionPath = 'pill_sheet_types';

  /// 文字列のパスからPillSheetTypeのenumを生成する。
  /// Firestoreのドキュメント識別子から対応するenumを取得する際に使用。
  /// 不正な値の場合はArgumentErrorを投げる。
  static PillSheetType fromRawPath(String rawPath) {
    switch (rawPath) {
      case 'pillsheet_21':
        return PillSheetType.pillsheet_21;
      case 'pillsheet_28_4':
        return PillSheetType.pillsheet_28_4;
      case 'pillsheet_28_7':
        return PillSheetType.pillsheet_28_7;
      case 'pillsheet_28_0':
        return PillSheetType.pillsheet_28_0;
      case 'pillsheet_24_0':
        return PillSheetType.pillsheet_24_0;
      case 'pillsheet_21_0':
        return PillSheetType.pillsheet_21_0;
      case 'pillsheet_24_rest_4':
        return PillSheetType.pillsheet_24_rest_4;
      default:
        throw ArgumentError.notNull('');
    }
  }

  /// ピルシートタイプの多言語対応された表示名を取得する。
  /// UI表示でユーザーに見せる正式名称。
  /// ローカライゼーション（L）クラスから対応する文字列を取得する。
  String get fullName {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return L.pillSheetType21With7Placebo;
      case PillSheetType.pillsheet_28_4:
        return L.pillSheetType28With4Placebo;
      case PillSheetType.pillsheet_28_7:
        return L.pillSheetType28With7Placebo;
      case PillSheetType.pillsheet_28_0:
        return L.pillSheetType28;
      case PillSheetType.pillsheet_24_0:
        return L.pillSheetType24;
      case PillSheetType.pillsheet_21_0:
        return L.pillSheetType21;
      case PillSheetType.pillsheet_24_rest_4:
        return L.pillSheetType24WithRest4;
    }
  }

  /// Firestoreドキュメント識別子として使用される文字列パスを取得する。
  /// データベース保存・検索時のキーとして使用される。
  /// enum名と同じ文字列を返す。
  String get rawPath {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 'pillsheet_21';
      case PillSheetType.pillsheet_28_4:
        return 'pillsheet_28_4';
      case PillSheetType.pillsheet_28_7:
        return 'pillsheet_28_7';
      case PillSheetType.pillsheet_28_0:
        return 'pillsheet_28_0';
      case PillSheetType.pillsheet_24_0:
        return 'pillsheet_24_0';
      case PillSheetType.pillsheet_21_0:
        return 'pillsheet_21_0';
      case PillSheetType.pillsheet_24_rest_4:
        return 'pillsheet_24_rest_4';
    }
  }

  /// ピルシートタイプに対応するSVG画像を取得する。
  /// UI表示用のアセット画像ファイルをSvgPictureとして読み込む。
  /// 各タイプ固有のビジュアル表現を提供する。
  SvgPicture get image {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return SvgPicture.asset('images/pillsheet_21.svg');
      case PillSheetType.pillsheet_28_4:
        return SvgPicture.asset('images/pillsheet_28_4.svg');
      case PillSheetType.pillsheet_28_7:
        return SvgPicture.asset('images/pillsheet_28_7.svg');
      case PillSheetType.pillsheet_28_0:
        return SvgPicture.asset('images/pillsheet_28_0.svg');
      case PillSheetType.pillsheet_24_0:
        return SvgPicture.asset('images/pillsheet_24_0.svg');
      case PillSheetType.pillsheet_21_0:
        return SvgPicture.asset('images/pillsheet_21_0.svg');
      case PillSheetType.pillsheet_24_rest_4:
        return SvgPicture.asset('images/pillsheet_28_4.svg');
    }
  }

  /// ピルシートの総錠数を取得する。
  /// 実薬と偽薬の合計数を表す。
  /// ピルシートUI表示やサイクル計算で使用される。
  int get totalCount {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 28;
      case PillSheetType.pillsheet_28_4:
        return 28;
      case PillSheetType.pillsheet_28_7:
        return 28;
      case PillSheetType.pillsheet_28_0:
        return 28;
      case PillSheetType.pillsheet_24_0:
        return 24;
      case PillSheetType.pillsheet_21_0:
        return 21;
      case PillSheetType.pillsheet_24_rest_4:
        return 28;
    }
  }

  /// 実薬の服用期間（日数）を取得する。
  /// 偽薬や休薬期間を除いた、実際にピルを服用する日数。
  /// 服用履歴の管理や次回生理予測で使用される。
  int get dosingPeriod {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 21;
      case PillSheetType.pillsheet_28_4:
        return 24;
      case PillSheetType.pillsheet_28_7:
        return 21;
      case PillSheetType.pillsheet_28_0:
        return 28;
      case PillSheetType.pillsheet_24_0:
        return 24;
      case PillSheetType.pillsheet_21_0:
        return 21;
      case PillSheetType.pillsheet_24_rest_4:
        return 24;
    }
  }

  /// ピルシートタイプの基本情報をまとめたオブジェクトを取得する。
  /// Firestoreパス、名前、総錠数、服用期間を含む構造体。
  /// データ転送やAPI通信で使用される。
  PillSheetTypeInfo get typeInfo => PillSheetTypeInfo(
    pillSheetTypeReferencePath: rawPath,
    name: fullName,
    totalCount: totalCount,
    dosingPeriod: dosingPeriod,
  );

  /// 休薬期間または偽薬期間を持つかどうかを判定する。
  /// 総錠数と服用期間が異なる場合にtrueを返す。
  /// UI表示での条件分岐や生理周期計算で使用される。
  bool get hasRestOrFakeDuration {
    return totalCount != dosingPeriod;
  }

  /// 休薬・偽薬期間の表示用文言を取得する。
  /// 「休薬期間」「偽薬」または空文字列を返す。
  /// UI表示でユーザーに期間の種類を説明する際に使用される。
  String get notTakenWord {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return L.restPeriod;
      case PillSheetType.pillsheet_28_4:
        return L.placebo;
      case PillSheetType.pillsheet_28_7:
        return L.placebo;
      case PillSheetType.pillsheet_28_0:
        return '';
      case PillSheetType.pillsheet_24_0:
        return '';
      case PillSheetType.pillsheet_21_0:
        return '';
      case PillSheetType.pillsheet_24_rest_4:
        return L.restPeriod;
    }
  }

  /// ピルシートUIで表示する行数を計算する。
  /// 総錠数を週日数（7日）で割った値の切り上げ。
  /// ピルシートの縦方向のレイアウト設計で使用される。
  int get numberOfLineInPillSheet =>
      (totalCount / Weekday.values.length).ceil();
}

/// 複数のピルシートタイプから指定インデックスまでの総ピル数を計算する関数。
/// ピルシート履歴の中で、特定の位置までの累積服用数を求める。
/// インデックスが0の場合は0を返し、それ以外は指定インデックス前までの合計数を返す。
int summarizedPillCountWithPillSheetTypesToIndex({
  required List<PillSheetType> pillSheetTypes,
  required int toIndex,
}) {
  if (toIndex == 0) {
    return 0;
  }

  final passed = pillSheetTypes.sublist(0, toIndex);
  final passedTotalCount = passed
      .map((e) => e.totalCount)
      .reduce((value, element) => value + element);
  return passedTotalCount;
}
