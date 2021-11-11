import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/demography/demography_completed_dialog.dart';
import 'package:pilll/domain/demography/demography_page_state.dart';
import 'package:pilll/domain/demography/demography_page_store.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _unknown = "該当なし";

class DemographyPage extends HookWidget {
  final VoidCallback done;

  DemographyPage(this.done);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(demographyPageStoreProvider);
    final state = useProvider(demographyPageStoreProvider.state);
    final purpose1 = state.purpose1;
    final prescription = state.prescription;
    final birthYear = state.birthYear;
    final lifeTime = state.lifeTime;
    final demographic = state.demographic();
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
                      context,
                      "ピルを服用している1番の目的",
                      GestureDetector(
                        child: Text(purpose1 == null ? "選択してください" : purpose1,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showPurposePicker1(context, store, state),
                      ),
                    ),
                    if (purpose1 != _unknown) ...[
                      SizedBox(height: 30),
                      _layout(
                        context,
                        "その他ピルを服用している目的があれば教えて下さい",
                        GestureDetector(
                          child: Text(state.purpose2,
                              style: FontType.assisting
                                  .merge(TextColorStyle.black)),
                          onTap: () =>
                              _showPurposePicker2(context, store, state),
                        ),
                      ),
                    ],
                    SizedBox(height: 30),
                    _layout(
                      context,
                      "ピルの処方はどのように行っていますか？",
                      GestureDetector(
                        child: Text(
                            prescription == null ? "選択してください" : prescription,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () =>
                            _showPrescriptionPicker(context, store, state),
                      ),
                    ),
                    SizedBox(height: 30),
                    _layout(
                      context,
                      "生まれ年を教えて下さい",
                      GestureDetector(
                        child: Text(birthYear == null ? "選択してください" : birthYear,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () =>
                            _showBirthYearPicker(context, store, state),
                      ),
                    ),
                    SizedBox(height: 30),
                    _layout(
                      context,
                      "いつもどのようなタイミングでピルを服用していますか？",
                      GestureDetector(
                        child: Text(lifeTime == null ? "選択してください" : lifeTime,
                            style:
                                FontType.assisting.merge(TextColorStyle.black)),
                        onTap: () => _showLifeTimePicker(context, store, state),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 44),
              child: PrimaryButton(
                onPressed: demographic == null
                    ? null
                    : () async {
                        analytics.logEvent(
                            name: "demographic_done_button_pressed");
                        final sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setBool(
                            BoolKey.isAlreadyDoneDemography, true);
                        await store.register(demographic);
                        Navigator.of(context).pop();
                        this.done();
                      },
                text: "完了",
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _columnWidth(BuildContext context) =>
      MediaQuery.of(context).size.width - 39 * 2;

  Widget _layout(BuildContext context, String title, Widget form) {
    return Center(
      child: Container(
        width: _columnWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FontType.assisting.merge(TextColorStyle.black)),
            SizedBox(height: 10),
            Container(
              width: _columnWidth(context),
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

  _showPurposePicker1(
    BuildContext context,
    DemographyPageStore store,
    DemographyPageState state,
  ) {
    analytics.logEvent(name: "show_purpose_picker_1");
    final dataSource = DemographyPageDataSource.purposes;
    String? selected = state.purpose1 ?? dataSource.first;
    final purpose = state.purpose1;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                final _selected = selected;
                if (_selected != null) {
                  analytics
                      .logEvent(name: "done_purpose_picker_1", parameters: {
                    "before": state.purpose1,
                    "after": _selected,
                  });
                  analytics.setUserProperties("purpose_1", _selected);
                  store.setPurpose1(_selected);
                }
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
                    analytics.logEvent(
                        name: "did_select_purpose_picker_1",
                        parameters: {"purpose": dataSource[index]});
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

  _showPurposePicker2(
    BuildContext context,
    DemographyPageStore store,
    DemographyPageState state,
  ) {
    analytics.logEvent(name: "show_purpose_picker_2");
    final dataSource = DemographyPageDataSource.purposes
        .where((element) => element != state.purpose1)
        .toList();

    String selected = state.purpose2;
    final purpose = state.purpose2;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                analytics.logEvent(name: "done_purpose_picker_2", parameters: {
                  "before": purpose,
                  "after": selected,
                });
                analytics.setUserProperties("purpose_2", selected);
                store.setPurpose2(selected);
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
                    analytics.logEvent(
                        name: "did_select_purpose_picker_2",
                        parameters: {"purpose": dataSource[index]});
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

  _showPrescriptionPicker(
    BuildContext context,
    DemographyPageStore store,
    DemographyPageState state,
  ) {
    analytics.logEvent(name: "show_prescription_picker");
    final dataSource = [
      "病院",
      "オンライン",
      "海外から個人輸入",
      "海外在住で薬局購入",
      _unknown,
    ];
    String? selected = state.prescription ?? dataSource.first;
    final prescription = state.prescription;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                final _selected = selected;
                if (_selected != null) {
                  analytics
                      .logEvent(name: "done_prescription_picker", parameters: {
                    "before": state.prescription,
                    "after": _selected,
                  });
                  analytics.setUserProperties("prescription", _selected);
                  store.setPrescription(_selected);
                }
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
                    analytics.logEvent(
                        name: "did_select_prescription_picker",
                        parameters: {"prescription": dataSource[index]});
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

  _showBirthYearPicker(
    BuildContext context,
    DemographyPageStore store,
    DemographyPageState state,
  ) {
    analytics.logEvent(name: "show_birth_year_picker");
    final dataSource = DemographyPageDataSource.birthYears;
    String? selected =
        state.birthYear ?? "${DemographyPageDataSource.defaultBirthYear}";
    final birthYear = state.birthYear;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                final _selected = selected;
                if (_selected != null) {
                  analytics
                      .logEvent(name: "done_birth_year_picker", parameters: {
                    "before": birthYear,
                    "after": _selected,
                  });
                  analytics.setUserProperties("birth_year", _selected);
                  store.setBirthYear(_selected);
                }
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
                    analytics.logEvent(
                        name: "did_select_birth_year_picker",
                        parameters: {"birth_year": dataSource[index]});
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: birthYear == null
                          ? dataSource.indexOf(
                              "${DemographyPageDataSource.defaultBirthYear}")
                          : dataSource.indexOf(birthYear)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showLifeTimePicker(
    BuildContext context,
    DemographyPageStore store,
    DemographyPageState state,
  ) {
    analytics.logEvent(name: "show_life_time_picker");
    final dataSource = DemographyPageDataSource.lifeTimes;
    String? selected = state.lifeTime ?? dataSource.first;
    final lifeTime = state.lifeTime;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                final _selected = selected;
                if (_selected != null) {
                  analytics
                      .logEvent(name: "done_life_time_picker", parameters: {
                    "before": state.lifeTime,
                    "after": _selected,
                  });
                  analytics.setUserProperties("lifeTime", selected);
                  store.setLifeTime(_selected);
                }
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
                    analytics.logEvent(
                        name: "did_select_life_time_picker",
                        parameters: {"lifeTime": dataSource[index]});
                    selected = dataSource[index];
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          lifeTime == null ? 0 : dataSource.indexOf(lifeTime)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension _DemographyPageRoute on DemographyPage {
  static Route<dynamic> route(VoidCallback done) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "DemographyPage"),
      builder: (_) => DemographyPage(
        done,
      ),
    );
  }
}

showDemographyPageIfNeeded(BuildContext context) async {
  final sharedPreference = await SharedPreferences.getInstance();
  final isAlreadyShowDemography =
      sharedPreference.getBool(BoolKey.isAlreadyShowDemography);

  if (isAlreadyShowDemography == true) {
    return;
  }
  sharedPreference.setBool(BoolKey.isAlreadyShowDemography, true);

  Navigator.of(context).push(_DemographyPageRoute.route(() {
    showDemographyCompletedDialog(context);
  }));
}
