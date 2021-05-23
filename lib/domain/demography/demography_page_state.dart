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
    String? job,
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
    "婦人病の治療",
    "生理・PMSの症状緩和",
    "生理不順のため",
    "避妊のため",
    "美容のため",
    "ホルモン療法",
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

  static final jobs = [
    "建築業",
    "製造業",
    "情報通信業",
    "運送業・郵便業",
    "電気・ガス・熱供給・水道業",
    "卸売・小売業",
    "金融業・保険業",
    "不動産業・物品賃貸業",
    "学術研究",
    "技術サービス(測量など)",
    "専門サービス(法律・税理士など)",
    "教育・学習支援業",
    "宿泊業・飲食サービス業",
    "生活関連サービス業・娯楽業",
    "その他サービス業全般",
    "医療・介護・福祉",
    "公務",
    "農業・林業",
    "鉱業・採石業・砂利採取業",
    "主婦",
    "学生",
    unknown,
  ];
}
