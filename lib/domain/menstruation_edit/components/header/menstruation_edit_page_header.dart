import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state_notifier.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

class MenstruationEditPageHeader extends StatelessWidget {
  final String title;
  final Menstruation? menstruation;
  final MenstruationEditPageStateNotifier store;
  final Function() onDeleted;
  final Function(Menstruation) onSaved;

  const MenstruationEditPageHeader({
    Key? key,
    required this.title,
    required this.menstruation,
    required this.store,
    required this.onDeleted,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: FontType.sBigTitle.merge(TextColorStyle.main)),
        const Spacer(),
        AlertButton(
          onPressed: () async {
            analytics.logEvent(name: "pressed_saving_menstruation_edit");
            if (store.shouldShowDiscardDialog()) {
              showDialog(
                context: context,
                builder: (context) => DiscardDialog(
                  title: "生理期間を削除しますか？",
                  message: const Text(""),
                  actions: [
                    AlertButton(
                      text: "キャンセル",
                      onPressed: () async {
                        analytics.logEvent(name: "cancelled_delete_menstruation");
                        Navigator.of(context).pop();
                      },
                    ),
                    AlertButton(
                      text: "削除する",
                      onPressed: () async {
                        await store.asyncAction.delete(
                          initialMenstruation: store.initialMenstruation,
                          menstruation: menstruation,
                        );
                        onDeleted();

                        analytics.logEvent(name: "pressed_delete_menstruation");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else if (store.isDismissWhenSaveButtonPressed()) {
              Navigator.of(context).pop();
            } else {
              store.asyncAction
                  .save(
                    initialMenstruation: store.initialMenstruation,
                    menstruation: menstruation,
                  )
                  .then((value) => onSaved(value));
            }
          },
          text: "保存",
        )
      ],
    );
  }
}
