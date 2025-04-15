import 'package:flutter/material.dart';
import 'app_store_review_card.dart'; // 作成したカードWidgetをインポート

// レビューカードのデータを保持するクラスは削除
// class AppStoreReviewCardData {
//   final double rating;
//   final int reviewCount;
//   final VoidCallback? onTap;
//
//   const AppStoreReviewCardData({
//     required this.rating,
//     required this.reviewCount,
//     this.onTap,
//   });
// }

class AppStoreReviewCards extends StatelessWidget {
  const AppStoreReviewCards({
    super.key,
    // cardDataList 引数は削除
    this.spacing = 8.0, // カード間のデフォルトスペース
  });

  // 表示するレビューカードデータのリストは削除
  // final List<AppStoreReviewCardData> cardDataList;
  // カード間のスペース
  final double spacing;

  @override
  Widget build(BuildContext context) {
    // サンプルデータに基づいて AppStoreReviewCard を直接配置
    final reviews = [
      // レビュー1: ★★★★★
      const AppStoreReviewCard(rating: 5.0),
      // レビュー2: ★★★★★
      const AppStoreReviewCard(rating: 5.0),
      // レビュー3: ★★★★★
      const AppStoreReviewCard(rating: 5.0),
      // レビュー4: ★★
      const AppStoreReviewCard(rating: 2.0), // 提示されたレビューに基づき★2に設定
    ];

    return Row(
      // Row内の要素を均等に配置するか、Startに寄せるかなどは必要に応じて調整
      mainAxisAlignment: MainAxisAlignment.start, // 左寄せにする場合
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置にする場合
      children: List.generate(reviews.length * 2 - 1, (index) {
        if (index.isEven) {
          final reviewIndex = index ~/ 2;
          // 各カードをExpandedでラップ
          return Expanded(child: reviews[reviewIndex]);
        } else {
          // カード間のスペース
          return SizedBox(width: spacing);
        }
      }),
    );
  }
}
