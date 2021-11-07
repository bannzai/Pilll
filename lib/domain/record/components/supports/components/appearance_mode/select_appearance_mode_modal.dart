import 'package:flutter/material.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';

class SelectAppearanceModeModal extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetAppearanceMode mode;

  const SelectAppearanceModeModal(
      {Key? key, required this.store, required this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

void showSelectAppearanceModeModal(
  BuildContext context, {
  required RecordPageStore store,
  required PillSheetAppearanceMode mode,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(store: store, mode: mode),
    backgroundColor: Colors.transparent,
  );
}
