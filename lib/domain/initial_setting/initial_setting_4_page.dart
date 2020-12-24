import 'package:Pilll/router/router.dart';
import 'package:Pilll/entity/initial_setting.dart';
import 'package:Pilll/store/initial_setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';

class InitialSetting4Page extends HookWidget {
  Widget _time(BuildContext context, InitialSettingModel entity) {
    return Text(
      DateTimeFormatter.militaryTime(entity.reminderDateTime()),
      style: FontType.largeNumber.merge(
        TextStyle(
          decoration: TextDecoration.underline,
          color: TextColor.black,
        ),
      ),
    );
  }

  void _showDurationModalSheet(
    BuildContext context,
    InitialSettingModel entity,
    InitialSettingStateStore store,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: entity.reminderDateTime(),
          done: (dateTime) {
            store.modify((model) => model.copyWith(
                reminderHour: dateTime.hour, reminderMinute: dateTime.minute));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _form(int index) {
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
          Container(
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
              child: Text("22:00",
                  style: FontType.inputNumber.merge(TextColorStyle.gray)),
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
        backgroundColor: PilllColors.background,
      ),
      body: Container(
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
                          return _form(index);
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
                    text: TextSpan(
                      // プライバシーポリシーと利用規約を同意の上、お進みください
                      children: [
                        TextSpan(
                          text: "プライバシーポリシー",
                          style: FontType.mini.merge(TextColorStyle.link),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("tapped privacy policy");
                            },
                        ),
                        TextSpan(
                          text: "と",
                          style: FontType.mini.merge(TextColorStyle.gray),
                        ),
                        TextSpan(
                          text: "利用規約",
                          style: FontType.mini.merge(TextColorStyle.link),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("tapped terms");
                            },
                        ),
                        TextSpan(
                          text: "を同意の上、お進みください",
                          style: FontType.mini.merge(TextColorStyle.gray),
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
