import 'package:flutter/material.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_banner.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob_native_advanced.dart';

class AdMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // iPhone mini, iPhone SEサイズだとNativeAdvanceの広告の高さだと画面占領が目立つので高さで広告を分岐する
    // SE(2nd)もminiも将来的にサポート対象外(どちらも生産終了)しているので、この分岐は将来的には不要になる
    // miniは確認した限りでは90pxの高さでもさほど問題はなかったが、ついでなのでminiも含めて分岐してしまう。Androidの小さい端末もこのコードでカバーできるだろうと目論んでいる
    // mini: 812, SE(2nd): 667
    if (MediaQuery.of(context).size.height <= 812) {
      return const AdMobBanner();
    } else {
      return const AdMobNativeAdvance();
    }
  }
}
