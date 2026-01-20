import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app_store_review_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppStoreReviewCards extends HookConsumerWidget {
  const AppStoreReviewCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(viewportFraction: 0.85);
    final currentPage = useState(0);

    final reviews = [
      const AppStoreReviewCard(
        rating: 5.0,
        title: '対応が早い。愛用アプリです',
        author: 'えりりんー',
        message:
            '数日前に、「1年以上前のカレンダーが見れない」と問い合わせをしたら、「1年以上前のデータの閲覧は想定されていない」「過去データを見るきっかけを今後の改善の参考にしたい」とのお返事をいただきました。そのあときっかけとなる出来事があったことを返信しました。'
            'そうしたらなんと、このやり取りの数日後に「10年分のカレンダーを閲覧出来るようにアプデしました」とのメールが届きました。アプデしてみると、つい数日前まで見れていなかった過去データも確認できるようになっていました！'
            'このアプリに体調管理を任せていたので本当に助かりました。'
            '問い合わせからお返事を頂くまで、そこからアップデートまで、全ての対応が丁寧で早く、とてもありがたかったです。'
            'このアプリに携わる皆様本当にありがとうございました！これからも使っていきます！',
      ),
      const AppStoreReviewCard(
        rating: 5.0,
        title: '丁寧に作られているアプリです。',
        author: '縁の下のぬか床',
        message:
            'ピル服用を始めるにあたって、いくつかアプリを試しましたが、このアプリが1番気に入っています。'
            'まずはデザインがいいこと。'
            '余計な情報が少なく、デザインも洗練されていて、使い易さを感じます。'
            '次に、要望へのレスポンスが早いことがとても素晴らしいです。'
            '対応していただくのはとても大変だと思うのですが、こちらのアプリでは良いアプリを作ろうという気概が伝わってきます。'
            '実際、私の要望も検討していただき、さらに使いやすくなっていました。'
            'ピルの利用法は人によって様々なので、万人に合うアプリではないかもしれませんが、進化し続けている誠意あるアプリです。'
            '実際使いやすいので、アプリに迷っている方にまずお勧めしたいです。',
      ),
      const AppStoreReviewCard(
        rating: 5.0,
        title: 'シンプルで使いやすい',
        author: 'Julie0209',
        message:
            '以前有名どころを使っていましたが、多機能ゆえ煩わしい点が多かったです。（受診日を設定しないと次のシートを表示できない等）'
            'こちらのアプリは非常にシンプルで通知も複数回設定でき飲み忘れ防止にも期待できます。',
      ),
      const AppStoreReviewCard(
        rating: 5.0,
        title: '欲しかった機能です',
        author: 'げんしちゃん',
        message:
            '月経に関連するアプリは様々ありますが、今まで試した中で一番使いやすいです。'
            '他のアプリではどうしても妊娠や生理周期に関する記録がメインで、ピルの服用を忘れずに記録していきたいが主目的の場合どうしても余計なものが多く、目的を果たせませんでした。'
            'このアプリはシートの種別を選択して管理できるので本当に助かります！'
            '長く続いて欲しいので追々課金もさせていただきます。どうかこの痒いところに手が届くけど記入するものは多すぎない感じで今後もよろしくお願いします。',
      ),
    ];

    return Column(
      children: [
        const Text(
          'ストアの評価もご覧ください',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: pageController,
            itemCount: reviews.length,
            onPageChanged: (index) {
              currentPage.value = index;
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: reviews[index],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // ページインジケーター
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            reviews.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentPage.value == index ? 24 : 8,
              decoration: BoxDecoration(
                color: currentPage.value == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
