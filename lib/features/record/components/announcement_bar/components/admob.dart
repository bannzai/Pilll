import 'package:flutter/material.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_banner.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_native_advanced.dart';

class AdMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // iPhone mini, iPhone SEサイズだとNativeAdvanceの広告の高さだと画面占領が目立つので高さで広告を分岐する
    // SEもminiも将来的にサポート対象外(どちらも生産終了)しているので、この分岐は将来的には不要になる
    // iPhone SEはiOS15までサポートされているので、2024-01以降にiOSのバージョンを16に上げて回避するでも良さそう
    // ただ、一時的にサポートするコードを書いてしまっているので、iOSのバージョンを上げるのは必須じゃない。2024-01以降で他に困ることがあればiOSのバージョンを上げる
    // mini: 780, SE: 667
    if (MediaQuery.of(context).size.height <= 780) {
      return const AdMobBanner();
    } else {
      return const AdMobNativeAdvance();
    }
  }
}
