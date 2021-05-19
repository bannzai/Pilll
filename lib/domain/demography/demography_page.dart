import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';

class DemographyPage extends StatefulWidget {
  @override
  _DemographyPageState createState() => _DemographyPageState();
}

String _unknown = "該当なし";
final _purposeDataSource = [
  "婦人病の治療",
  "生理・PMSの症状緩和",
  "生理不順のため",
  "避妊のため",
  "美容のため",
  "ホルモン療法",
  _unknown,
];

class _DemographyPageState extends State<DemographyPage> {
  String? _purpose1;
  String _purpose2 = _unknown;
  String? _prescription;
  String? _birthYear;
  String? _job;
  @override
  Widget build(BuildContext context) {
    final purpose1 = _purpose1;
    final prescription = _prescription;
    final birthYear = _birthYear;
    final job = _job;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.only(top: 60),
                  children: [
                    Text(
                      "あなたについて\n少しだけ教えて下さい",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 36),
                    _layout(
                      "ピルを服用している1番の目的/理由",
                      GestureDetector(
                        child: Text(purpose1 == null ? "選択してください" : purpose1,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showPurposePicker1(),
                      ),
                    ),
                    if (purpose1 != _unknown) ...[
                      SizedBox(height: 30),
                      _layout(
                        "ピルを服用しているその他の目的/理由",
                        GestureDetector(
                          child: Text(_purpose2,
                              style: FontType.assisting
                                  .merge(TextColorStyle.black)),
                          onTap: () => _showPurposePicker2(),
                        ),
                      ),
                    ],
                    SizedBox(height: 30),
                    _layout(
                      "ピルの処方はどのように行っていますか？",
                      GestureDetector(
                        child: Text(
                            prescription == null ? "選択してください" : prescription,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showPrescriptionPicker(),
                      ),
                    ),
                    SizedBox(height: 30),
                    _layout(
                      "生まれ年を教えて下さい",
                      GestureDetector(
                        child: Text(birthYear == null ? "選択してください" : birthYear,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showBirthYearPicker(),
                      ),
                    ),
                    SizedBox(height: 30),
                    _layout(
                      "職業",
                      GestureDetector(
                        child: Text(job == null ? "選択してください" : job,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showJobPicker(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 44),
              child: PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: "完了",
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _columnWidht() => MediaQuery.of(context).size.width - 39 * 2;

  Widget _layout(String title, Widget form) {
    return Center(
      child: Container(
        width: _columnWidht(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FontType.assisting.merge(TextColorStyle.black)),
            SizedBox(height: 10),
            Container(
              width: _columnWidht(),
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: PilllColors.border),
                  borderRadius: BorderRadius.circular(4)),
              child: form,
            ),
          ],
        ),
      ),
    );
  }

  _showPurposePicker1() {
    final dataSource = _purposeDataSource;
    String? selected = _purpose1;
    final purpose = _purpose1;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  _purpose1 = selected;
                });
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: dataSource.map((v) => Text(v)).toList(),
                  onSelectedItemChanged: (index) {
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          purpose == null ? 0 : dataSource.indexOf(purpose)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showPurposePicker2() {
    final dataSource =
        _purposeDataSource.where((element) => element != _purpose1).toList();
    String selected = _purpose2;
    final purpose = _purpose2;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  _purpose2 = selected;
                });
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: dataSource.map((v) => Text(v)).toList(),
                  onSelectedItemChanged: (index) {
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: dataSource.indexOf(purpose)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showPrescriptionPicker() {
    final dataSource = [
      "病院",
      "オンライン",
      "海外から個人輸入",
      "海外在住で薬局購入",
      _unknown,
    ];
    String? selected = _prescription;
    final prescription = _prescription;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  _prescription = selected;
                });
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: dataSource.map((v) => Text(v)).toList(),
                  onSelectedItemChanged: (index) {
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: prescription == null
                          ? 0
                          : dataSource.indexOf(prescription)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showBirthYearPicker() {
    final offset = 1950;
    final dataSource = [
      ...List.generate(today().year - offset, (index) => offset + index)
          .reversed
          .map((e) => e.toString()),
      _unknown,
    ];
    String? selected = _birthYear;
    final birthYear = _birthYear;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  _birthYear = selected;
                });
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: dataSource.map((v) => Text(v)).toList(),
                  onSelectedItemChanged: (index) {
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: birthYear == null
                          ? dataSource.indexOf("2000")
                          : dataSource.indexOf(birthYear)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showJobPicker() {
    final dataSource = [
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
      _unknown,
    ];
    String? selected = _job;
    final job = _job;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  _job = selected;
                });
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: dataSource.map((v) => Text(v)).toList(),
                  onSelectedItemChanged: (index) {
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: job == null ? 0 : dataSource.indexOf(job)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension DemographyPageRoute on DemographyPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "DemographyPage"),
      builder: (_) => DemographyPage(),
    );
  }
}
