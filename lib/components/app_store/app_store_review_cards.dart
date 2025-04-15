import 'package:flutter/material.dart';
import 'app_store_review_card.dart'; // 作成したカードWidgetをインポート

// レビューカードのデータを保持するクラス
class AppStoreReviewCardData {
  final double rating;
  final int reviewCount;
  final VoidCallback? onTap;

  const AppStoreReviewCardData({
    required this.rating,
    required this.reviewCount,
    this.onTap,
  });
}

class AppStoreReviewCards extends StatelessWidget {
  const AppStoreReviewCards({
    super.key,
    required this.cardDataList,
    this.spacing = 8.0, // カード間のデフォルトスペース
  });

  // 表示するレビューカードデータのリスト
  final List<AppStoreReviewCardData> cardDataList;
  // カード間のスペース
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      // Row内の要素を均等に配置するか、Startに寄せるかなどは必要に応じて調整
      mainAxisAlignment: MainAxisAlignment.start, // 左寄せにする場合
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置にする場合
      children: cardDataList.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final card = AppStoreReviewCard(
          rating: data.rating,
          onTap: data.onTap,
          // AppStoreReviewCardの他のプロパティ（backgroundColorなど）も
          // 必要に応じてAppStoreReviewCardDataに追加して渡すことができます
        );

        // リストの最後の要素以外にはスペースを追加
        if (index < cardDataList.length - 1) {
          return Expanded(
            // Row内で要素がスペースを奪い合わないようにExpandedで囲むことが多い
            child: Row(
              children: [
                Expanded(child: card), // カード自体もExpandedで囲む
                SizedBox(width: spacing),
              ],
            ),
          );
        } else {
          return Expanded(child: card); // 最後の要素
        }
      }).toList(),
    );
  }
}
