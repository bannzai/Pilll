import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiaryPostMemo extends HookConsumerWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final ValueNotifier<String> memo;
  const DiaryPostMemo({Key? key, required this.textEditingController, required this.focusNode, required this.memo}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textLength = 120;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 40,
        maxHeight: 200,
      ),
      child: TextFormField(
        onChanged: (text) {
          memo.value = text;
        },
        decoration: const InputDecoration(
          hintText: "メモ",
          border: OutlineInputBorder(),
        ),
        controller: textEditingController,
        maxLines: null,
        maxLength: textLength,
        keyboardType: TextInputType.multiline,
        focusNode: focusNode,
      ),
    );
  }
}
