import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/utils/analytics.dart';

/// 設定画面の行。タップするとアプリが利用しているOSSの名称とライセンス本文の一覧を表示する
///
/// 一覧はFlutter標準の[showLicensePage]が[LicenseRegistry]から組み立てるため、依存関係の追加・更新に自動で追従する
class OSSLicenseRow extends StatelessWidget {
  const OSSLicenseRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        // flutter_localizationsが70以上の言語で訳を持っているため、app_*.arbへキーを追加せずに多言語対応できる
        MaterialLocalizations.of(context).licensesPageTitle,
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      onTap: () async {
        analytics.logEvent(name: 'did_select_oss_license');

        // MaterialAppにtitleを設定していないため、applicationNameを省略するとiOSでは実行ファイル名の「Runner」が表示される
        final packageInfo = await PackageInfo.fromPlatform();
        if (!context.mounted) {
          return;
        }
        showLicensePage(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
        );
      },
    );
  }
}
