import 'package:pilll/router/router.dart';
import 'package:pilll/state/initial_setting.dart';
import 'package:pilll/store/initial_setting.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialSetting4Page extends HookWidget {
  void _showDurationModalSheet(
    BuildContext context,
    int index,
    InitialSettingState state,
    InitialSettingStateStore store,
  ) {
    final reminderDateTime = state.reminderTimeOrDefault(index);
    final n = now();
    DateTime initialDateTime = reminderDateTime != null
        ? reminderDateTime
        : DateTime(n.year, n.month, n.day, 22, 0, 0);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: initialDateTime,
          done: (dateTime) {
            store.setReminderTime(index, dateTime.hour, dateTime.minute);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _form(
    BuildContext context,
    InitialSettingStateStore store,
    InitialSettingState state,
    int index,
  ) {
    final reminderTime = state.reminderTimeOrDefault(index);
    final formValue = reminderTime == null
        ? "--:--"
        : DateTimeFormatter.militaryTime(reminderTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("images/alerm.svg"),
              Text("通知${index + 1}",
                  style: FontType.assisting.merge(TextColorStyle.main))
            ],
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showDurationModalSheet(context, index, state, store),
            child: Container(
              width: 81,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  width: 1,
                  color: PilllColors.border,
                ),
              ),
              child: Center(
                child: Text(formValue,
                    style: FontType.inputNumber.merge(TextColorStyle.gray)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "4/4",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Text(
                  "ピルの飲み忘れ通知",
                  style: FontType.title.merge(TextColorStyle.main),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return _form(context, store, state, index);
                          })),
                    ),
                    Text("複数設定しておく事で飲み忘れを防げます",
                        style: FontType.assisting.merge(TextColorStyle.main)),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "プライバシーポリシー",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.link),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    "https://bannzai.github.io/Pilll/PrivacyPolicy",
                                    forceSafariVC: true);
                              },
                          ),
                          TextSpan(
                            text: "と",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.gray),
                          ),
                          TextSpan(
                            text: "利用規約",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.link),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch("https://bannzai.github.io/Pilll/Terms",
                                    forceSafariVC: true);
                              },
                          ),
                          TextSpan(
                            text: "を読んで\n利用をはじめてください",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.gray),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    PrimaryButton(
                      text: "設定完了",
                      onPressed: () {
                        store
                            .register(state.entity.copyWith(isOnReminder: true))
                            .then((_) => AppRouter.endInitialSetting(context));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension InitialSetting4PageRoute on InitialSetting4Page {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSetting4Page"),
      builder: (_) => InitialSetting4Page(),
    );
  }
}
