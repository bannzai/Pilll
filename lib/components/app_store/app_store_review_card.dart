import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppStoreReviewCard extends StatelessWidget {
  const AppStoreReviewCard({
    super.key,
    this.rating = 5,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final double rating;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? _launchAppStore,
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
            Row(
              children: [
                _buildStarRating(),
                const SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  Future<void> _launchAppStore() async {
    const appStoreId = 'YOUR_APP_STORE_ID'; // ここにアプリのApp Store IDを設定
    final url = Uri.parse('https://apps.apple.com/app/id$appStoreId?action=write-review');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
