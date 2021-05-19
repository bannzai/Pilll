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

class _DemographyPageState extends State<DemographyPage> {
  String? _purpose;
  String? _prescription;
  String? _birthYear;
  @override
  Widget build(BuildContext context) {
    final purpose = _purpose;
    final prescription = _prescription;
    final birthYear = _birthYear;
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
                      "ピルを服用している目的/理由",
                      GestureDetector(
                        child: Text(purpose == null ? "選択してください" : purpose,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showPurposePicker(),
                      ),
                    ),
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
                      "年齢（生まれ年）を教えて下さい",
                      GestureDetector(
                        child: Text(birthYear == null ? "選択してください" : birthYear,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showBirthYearPicker(),
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

  _showPurposePicker() {
    final dataSource = [
      "婦人病の治療",
      "生理・PMSの症状緩和",
      "生理不順のため",
      "避妊のため",
      "美容のため",
      "ホルモン療法",
      "該当なし",
    ];
    String? selected = _purpose;
    final purpose = _purpose;
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
                  _purpose = selected;
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

  _showPrescriptionPicker() {
    final dataSource = [
      "病院",
      "オンライン",
      "海外から個人輸入",
      "海外在住で薬局購入",
      "該当なし",
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
      "該当なし",
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
}

extension DemographyPageRoute on DemographyPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "DemographyPage"),
      builder: (_) => DemographyPage(),
    );
  }
}
