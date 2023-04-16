import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/web_view.dart';
import 'package:pilll/utils/analytics.dart';

enum PreStoreReviewModalSelection { good, bad }

class PreStoreReviewModal extends HookConsumerWidget {
  const PreStoreReviewModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = useState<PreStoreReviewModalSelection?>(null);
    final selectionValue = selection.value;
    final navigator = Navigator.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 240,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pilllの感想をお聞かせください",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _goodOrBad(target: PreStoreReviewModalSelection.good, selection: selection),
                const SizedBox(width: 16),
                _goodOrBad(target: PreStoreReviewModalSelection.bad, selection: selection),
              ],
            ),
            if (selectionValue != null) ...[
              const Spacer(),
              PrimaryButton(
                onPressed: () async {
                  switch (selectionValue) {
                    case PreStoreReviewModalSelection.good:
                      analytics.logEvent(name: "submit_pre_store_review_modal_good");
                      break;
                    case PreStoreReviewModalSelection.bad:
                      analytics.logEvent(name: "submit_pre_store_review_modal_bad");
                      break;
                  }

                  await showDialog(
                    context: context,
                    builder: (_) => ThanksDialog(goodOrBad: selectionValue),
                  );
                  navigator.pop();
                },
                text: "決定",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _goodOrBad({required PreStoreReviewModalSelection target, required ValueNotifier<PreStoreReviewModalSelection?> selection}) {
    final isSelected = target == selection.value;
    return GestureDetector(
      onTap: () {
        switch (target) {
          case PreStoreReviewModalSelection.good:
            analytics.logEvent(name: "pre_store_review_modal_good");
            break;
          case PreStoreReviewModalSelection.bad:
            analytics.logEvent(name: "pre_store_review_modal_bad");
            break;
        }

        selection.value = target;
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? PilllColors.primary.withOpacity(0.08) : PilllColors.white,
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected ? PilllColors.primary : PilllColors.border,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  target == PreStoreReviewModalSelection.good ? "images/laugh.svg" : "images/angry.svg",
                  colorFilter: ColorFilter.mode(
                    isSelected ? PilllColors.primary : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(target == PreStoreReviewModalSelection.good ? "満足している" : "満足では無い",
                    style: const TextStyle(color: PilllColors.primary, fontWeight: FontWeight.bold, fontFamily: FontFamily.japanese)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThanksDialog extends StatelessWidget {
  final PreStoreReviewModalSelection goodOrBad;

  const ThanksDialog({
    Key? key,
    required this.goodOrBad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return AlertDialog(
      title: const Icon(
        Icons.thumb_up,
        color: PilllColors.primary,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("ご協力ありがとうございます",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: TextColor.main,
              )),
          SizedBox(
            height: 15,
          ),
          Text("よろしければサービス改善のためのアンケートにもご協力ください",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              )),
        ],
      ),
      actions: <Widget>[
        AlertButton(
          text: "協力する",
          onPressed: () async {
            final String uri;
            switch (goodOrBad) {
              case PreStoreReviewModalSelection.good:
                uri = "https://docs.google.com/forms/d/e/1FAIpQLScljawYCa-f13D94TvJXOoBQ_6lLBtwSpML5c55Zr115ukgeQ/viewform";
                break;
              case PreStoreReviewModalSelection.bad:
                uri = "https://docs.google.com/forms/d/e/1FAIpQLScdNJ5VsiWCNLk7LvSUJpb8ps0DHFnsvXVH8KbPWp9XDtuVMw/viewform";
                break;
            }
            await Navigator.of(context).push(
              WebViewPageRoute.route(
                title: "サービス改善アンケート",
                url: uri,
              ),
            );

            // ignore: use_build_context_synchronously
            showDialog(context: context, builder: (_) => const CompleteDialog());
          },
        ),
        AlertButton(
          text: "しない",
          onPressed: () async {
            navigator.pop();
          },
        ),
      ],
    );
  }
}

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: const Text(
        "ご協力頂きありがとうございます",
        style: TextStyle(
          fontFamily: FontFamily.japanese,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: TextColor.main,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "いただいた意見は今後の改善へと活用させていただきます。",
            style: TextStyle(
              fontFamily: FontFamily.japanese,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: TextColor.main,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        AlertButton(
          text: "閉じる",
          onPressed: () async {
            analytics.logEvent(name: "close_pre_store_review_modal_complete_dialog");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
