import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppStoreReviewCard extends HookWidget {
  const AppStoreReviewCard({super.key, required this.rating, required this.title, required this.author, required this.message});

  final double rating;
  final String title;
  final String author;
  final String message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // タップで詳細ダイアログを表示
        _showReviewDetailDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // 評価（星）
            Row(
              children: [
                _buildStarRating(),
                const SizedBox(width: 8),
                Text(rating.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),

            // 日付と著者
            if (author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // レビュー本文（常に最大5行まで）
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(message, style: const TextStyle(fontSize: 14), maxLines: 5, overflow: TextOverflow.ellipsis),
              ),

            // 「もっと見る」ボタン
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'タップして続きを読む',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showReviewDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 評価（星）
              Row(
                children: [
                  _buildStarRating(),
                  const SizedBox(width: 8),
                  Text(rating.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),

              // 著者
              if (author.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(author, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ),

              // メッセージ全文
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(message, style: const TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('閉じる'))],
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
