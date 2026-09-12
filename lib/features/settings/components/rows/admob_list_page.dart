import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_banner.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_native_advanced.dart';

/// AdMob の全広告 Widget を 1 画面に並べて確認するページ。
/// 開発者オプションからアクセスし、プレミアム状態や他の AnnouncementBar の優先順位・端末の画面高さに依存せず
/// バナー (アダプティブ) とネイティブ広告の表示 (サイズ・レイアウト) を横断的に検証する用途。
class AdMobListPage extends StatelessWidget {
  const AdMobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AdMob 一覧'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          Text('AdMobBanner (アンカー型アダプティブバナー)'),
          AdMobBanner(),
          SizedBox(height: 16),
          Text('AdMobNativeAdvance'),
          AdMobNativeAdvance(),
        ],
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する。
extension AdMobListPageRoute on AdMobListPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'AdMobListPage'),
        builder: (_) => const AdMobListPage(),
      );
}
