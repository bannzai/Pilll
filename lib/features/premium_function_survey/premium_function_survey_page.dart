import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/premium_function_survey/premium_function_survey_element.dart';
import 'package:pilll/features/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/links.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumFunctionSurveyPage extends HookConsumerWidget {
  const PremiumFunctionSurveyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = useState("");
    final selectedElements = useState<List<PremiumFunctionSurveyElementType>>([]);

    final sendPremiumFunctionSurvey = ref.watch(sendPremiumFunctionSurveyProvider);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 46.5),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "プレミアム体験が終了しました",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "もしよければ、便利だと感じた機能を教えて下さい！ぜひ、あなたのご意見をお聞かせください。",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.roboto,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      analytics.logEvent(name: "premium_link_tapped_on_survey");
                      await launchUrl(Uri.parse(preimumLink));
                    },
                    child: const Text("プレミアム機能の詳細はこちら",
                        style: TextStyle(fontSize: 12, fontFamily: FontFamily.japanese, fontWeight: FontWeight.w400, color: TextColor.primary)),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...PremiumFunctionSurveyElementType.values.map(
                        (e) => PremiumFunctionSurveyElement(
                          element: e,
                          selectedElements: selectedElements,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "その他ご意見等あれば教えて下さい",
                        style: TextStyle(color: TextColor.main, fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'ご意見、ご要望、開発者へ伝えたい事等',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onChanged: (text) {
                          message.value = text;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 37),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 44),
                    child: PrimaryButton(
                      onPressed: () async {
                        analytics.logEvent(name: "send_premium_function_survey");
                        try {
                          final navigator = Navigator.of(context);
                          await sendPremiumFunctionSurvey(selectedElements.value, message.value);
                          navigator.pop();
                        } catch (error) {
                          if (context.mounted) showErrorAlert(context, error);
                        }
                      },
                      text: "この内容で送る",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension PremiumFunctionSurveyPageRoutes on PremiumFunctionSurveyPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "PremiumFunctionSurveyPage"),
      builder: (_) => const PremiumFunctionSurveyPage(),
      fullscreenDialog: true,
    );
  }
}
