import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/inquiry.codegen.dart';
import 'package:pilll/features/localizations/l.dart';

class InquiryTypeSelector extends HookWidget {
  final ValueNotifier<InquiryType> selectedType;
  final ValueNotifier<String> otherTypeText;

  const InquiryTypeSelector({super.key, required this.selectedType, required this.otherTypeText});

  @override
  Widget build(BuildContext context) {
    final otherTextController = useTextEditingController(text: otherTypeText.value);

    void onInquiryTypeChanged(InquiryType? value) {
      if (value != null) {
        selectedType.value = value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.inquiryTypeLabel,
          style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        RadioListTile<InquiryType>(
          title: Text(L.bugReport, style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 16)),
          value: InquiryType.bugReport,
          groupValue: selectedType.value,
          onChanged: onInquiryTypeChanged,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<InquiryType>(
          title: Text(L.featureRequest, style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 16)),
          value: InquiryType.featureRequest,
          groupValue: selectedType.value,
          onChanged: onInquiryTypeChanged,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<InquiryType>(
          title: Text(L.otherInquiry, style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 16)),
          value: InquiryType.other,
          groupValue: selectedType.value,
          onChanged: onInquiryTypeChanged,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        if (selectedType.value == InquiryType.other)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: TextFormField(
              controller: otherTextController,
              onChanged: (text) {
                otherTypeText.value = text;
              },
              decoration: InputDecoration(hintText: L.otherInquiryPlaceholder, border: const OutlineInputBorder()),
              maxLength: 100,
            ),
          ),
      ],
    );
  }
}
