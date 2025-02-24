import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';

class DiaryPostMemo extends HookConsumerWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  const DiaryPostMemo({super.key, required this.textEditingController, required this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 40,
        maxHeight: 200,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: L.memo,
          border: const OutlineInputBorder(),
        ),
        controller: textEditingController,
        maxLines: null,
        maxLength: 120,
        focusNode: focusNode,
      ),
    );
  }
}
