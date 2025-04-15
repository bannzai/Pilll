import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppStoreReviewCard extends StatelessWidget {
  const AppStoreReviewCard({
    super.key,
    required this.rating,
    required this.title,
    required this.author,
    required this.date,
    required this.message,
    required this.onTap,
  });

  final double rating;
  final String title;
  final String author;
  final String date;
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // UIに関する設定を直接buildメソッド内に記述
    const padding = EdgeInsets.all(16);
    const borderRadius = BorderRadius.all(Radius.circular(12));
    const backgroundColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
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
            if (date.isNotEmpty || author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '$date・$author',
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
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
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
