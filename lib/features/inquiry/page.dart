import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/keyboard_toolbar.dart';
import 'package:pilll/entity/inquiry.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/inquiry/components/inquiry_type_selector.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/inquiry/inquiry.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/functions/firebase_functions.dart';
import 'package:pilll/utils/validator.dart';

class InquiryPage extends HookWidget {
  const InquiryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedType = useState(InquiryType.bugReport);
    final otherTypeText = useState('');
    final emailController = useTextEditingController();
    final contentController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final contentFocusNode = useFocusNode();
    final scrollController = useScrollController();
    final debugInfoFuture = useMemoized(() => debugInfo('\n'));
    final debugInfoSnapshot = useFuture(debugInfoFuture);
    final isSending = useState(false);

    bool isInvalid() {
      if (!isValidEmail(emailController.text)) return true;
      if (contentController.text.isEmpty) return true;
      if (selectedType.value == InquiryType.other && otherTypeText.value.isEmpty) return true;
      return false;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          L.contactUs,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: TextColor.main,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InquiryTypeSelector(
                        selectedType: selectedType,
                        otherTypeText: otherTypeText,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        L.emailAddress,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        L.emailReceiveSettingNote,
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                      Text(
                        L.emailCannotReceiveICloud,
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontSize: 12,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        decoration: InputDecoration(
                          hintText: L.emailPlaceholder,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(contentFocusNode);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        L.inquiryContent,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 120,
                          maxHeight: 200,
                        ),
                        child: TextFormField(
                          controller: contentController,
                          focusNode: contentFocusNode,
                          decoration: InputDecoration(
                            hintText: L.inquiryContentPlaceholder,
                            border: const OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: null,
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        L.debugInfoLabel,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          debugInfoSnapshot.data ?? 'Loading...',
                          style: const TextStyle(
                            fontFamily: FontFamily.roboto,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (emailFocusNode.hasPrimaryFocus || contentFocusNode.hasPrimaryFocus) ...[
                KeyboardToolbar(
                  doneButton: AlertButton(
                    text: L.completed,
                    onPressed: () async {
                      emailFocusNode.unfocus();
                      contentFocusNode.unfocus();
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              PrimaryButton(
                text: L.sendInquiry,
                onPressed: isInvalid() || isSending.value
                    ? null
                    : () => _submitInquiry(
                          context: context,
                          selectedType: selectedType.value,
                          otherTypeText: otherTypeText.value,
                          email: emailController.text,
                          content: contentController.text,
                          debugInfoText: debugInfoSnapshot.data ?? '',
                          isSending: isSending,
                        ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitInquiry({
    required BuildContext context,
    required InquiryType selectedType,
    required String otherTypeText,
    required String email,
    required String content,
    required String debugInfoText,
    required ValueNotifier<bool> isSending,
  }) async {
    analytics.logEvent(name: 'inquiry_submit_pressed');
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    isSending.value = true;
    try {
      await functions.inquiry(
        inquiryType: selectedType,
        otherTypeText: selectedType == InquiryType.other ? otherTypeText : null,
        email: email,
        content: content,
        debugInfo: debugInfoText,
      );

      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(L.inquirySent),
        ),
      );

      navigator.pop();
    } catch (error) {
      isSending.value = false;
      if (context.mounted) showErrorAlert(context, error);
    }
  }
}

extension InquiryPageRoute on InquiryPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'InquiryPage'),
      builder: (_) => const InquiryPage(),
      fullscreenDialog: true,
    );
  }
}
