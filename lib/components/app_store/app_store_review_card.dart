import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppStoreReviewCard extends HookWidget {
  const AppStoreReviewCard({
    super.key,
    required this.rating,
    required this.title,
    required this.author,
    required this.message,
  });

  final double rating;
  final String title;
  final String author;
  final String message;

  @override
  Widget build(BuildContext context) {
    // flutter_hooksを使って展開状態を管理
    final isExpanded = useState(false);

    // UIに関する設定を直接buildメソッド内に記述
    const padding = EdgeInsets.all(16);
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const backgroundColor = Colors.white;

    return GestureDetector(
      onTap: () {
        // タップで展開状態を切り替え
        isExpanded.value = !isExpanded.value;
      },
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // 評価（星）
            Row(
              children: [
                _buildStarRating(),
                const SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // 日付と著者
            if (author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // レビュー本文
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                  // 展開状態に応じてmaxLinesを切り替え
                  maxLines: isExpanded.value ? null : 5,
                  overflow: isExpanded.value ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ),

            // 展開状態の表示（オプション）
            if (message.isNotEmpty && !isExpanded.value)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'タップして続きを読む',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isHalfStar = rating > index && rating < starValue;
        final isFullStar = rating >= starValue;

        return Icon(
          isFullStar
              ? Icons.star
              : isHalfStar
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
