import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/demographic.dart';
import 'package:pilll/util/datetime/day.dart';

part 'demography_page_state.freezed.dart';

@freezed
abstract class DemographyPageState implements _$DemographyPageState {
  DemographyPageState._();
  factory DemographyPageState({
    String? purpose1,
    required String purpose2,
    String? prescription,
    String? birthYear,
    String? lifeTime,
  }) = _DemographyPageState;

  Demographic? demographic() {
    final purpose1 = this.purpose1;
    final purpose2 = this.purpose2;
    final prescription = this.prescription;
    final birthYear = this.birthYear;
    final job = this.job;
    if (purpose1 == null ||
        prescription == null ||
        birthYear == null ||
        job == null) {
      return null;
    }
    return Demographic(
        purpose1: purpose1,
        purpose2: purpose2,
        prescription: prescription,
        birthYear: birthYear,
        job: job);
  }
}

abstract class DemographyPageDataSource {
  static final unknown = "該当なし";
  static final purposes = [
    "過多月経・PMS等の改善",
    "月経不順の改善",
    "月経痛の緩和",
    "月経周期のコントロール",
    "治療のため",
    "避妊のため",
    "ニキビ・肌荒れの改善",
    unknown,
  ];
  static final prescriptions = [
    "病院",
    "オンライン",
    "海外から個人輸入",
    "海外在住で薬局購入",
    unknown,
  ];

  static final int birthYearBegin = 1950;
  static List<String> get birthYears {
    final offset = birthYearBegin;
    final dataSource = [
      ...List.generate(today().year - offset, (index) => offset + index)
          .reversed
          .map((e) => e.toString()),
      unknown,
    ];
    return dataSource;
  }

  static final lifeTimes = [
    "起床後",
    "朝食前後",
    "出社(通学)前",
    "出社(通学)後",
    "休憩時間",
    "おやつ前後",
    "ランチ前後",
    "帰宅前",
    "帰宅後",
    "夕食前後",
    "入浴前後",
    "就寝前",
    unknown,
  ];
}
