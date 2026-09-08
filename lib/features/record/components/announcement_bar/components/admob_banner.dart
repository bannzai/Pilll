import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pilll/secret/secret.dart';

/// アンカー型アダプティブバナー広告を読み込んで表示する
///
/// 固定サイズ (320x50) ではなく画面幅いっぱいのアダプティブバナーを要求する。
/// 固定サイズだと幅の余った端末では小さい広告しか配信されず eCPM が下がるため。
/// 参照: https://developers.google.com/admob/flutter/banner
class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  AdMobBannerState createState() => AdMobBannerState();
}

class AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;

  /// 読み込みを開始したかどうか。didChangeDependencies は複数回呼ばれるため、広告の二重読み込みを防ぐ
  bool _adLoadStarted = false;

  final String _adUnitId = Platform.isAndroid ? Secret.androidAdmobBannerIdentifier : Secret.iOSAdmobBannerIdentifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // アダプティブバナーのサイズ決定に画面幅 (MediaQuery) が必要で、initState では参照できないためここで読み込む
    if (!_adLoadStarted) {
      _adLoadStarted = true;
      _loadAd(width: MediaQuery.sizeOf(context).width.truncate());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (bannerAd != null) {
      return SafeArea(
        child: SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else {
      return Container();
    }
  }

  /// 画面幅に合わせたアンカー型アダプティブバナーを読み込む
  ///
  /// [width] は端末の画面幅 (dp)。AdMob 側が幅に応じた最適な高さを返す
  Future<void> _loadAd({required int width}) async {
    // 端末情報の取得に失敗した時などに null になる。その場合は広告を表示しない (従来と同じ挙動)
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (size == null) {
      return;
    }

    await BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
