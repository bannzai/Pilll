import 'package:flutter/material.dart';

class AppStoreReviewCard extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  const AppStoreReviewCard({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.backgroundColor = Colors.white,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              '$rating',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($reviewCount)',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
