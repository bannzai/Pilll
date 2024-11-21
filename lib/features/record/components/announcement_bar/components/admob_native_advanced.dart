import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pilll/secret/secret.dart';

class AdMobNativeAdvance extends StatefulWidget {
  const AdMobNativeAdvance({super.key});

  @override
  AdMobNativeAdvanceState createState() => AdMobNativeAdvanceState();
}

class AdMobNativeAdvanceState extends State<AdMobNativeAdvance> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = Platform.isAndroid ? Secret.androidAdmobNativeAdvanceIdentifier : Secret.iOSAdmobNativeAdvanceIdentifier;

  @override
  void initState() {
    super.initState();

    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: 32px is a minimum require height:https://support.google.com/admanager/answer/7031536?hl=en
    // NOTE: 90 is a minimum recommended height: https://developers.google.com/admob/flutter/native/templates
    // Ref: https://github.com/googleads/googleads-mobile-flutter/blob/4218712f5d06b972a9e2b65a44fd2889ae1d1390/samples/admob/native_template_example/lib/main.dart#L26
    const double adAspectRatioSmall = (91 / 355);
    final width = MediaQuery.of(context).size.width;
    final height = width * adAspectRatioSmall;
    if (_nativeAdIsLoaded && _nativeAd != null) {
      return SizedBox(height: height, width: width, child: AdWidget(ad: _nativeAd!));
    } else {
      return Container();
    }
  }

  /// Loads a native ad.
  void _loadAd() {
    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.small,
            mainBackgroundColor: const Color(0xfffffbed),
            callToActionTextStyle: NativeTemplateTextStyle(textColor: Colors.white, style: NativeTemplateFontStyle.monospace, size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.bold, size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.italic, size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.normal, size: 16.0)))
      ..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
