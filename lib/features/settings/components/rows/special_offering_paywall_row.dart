import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/special_offering/page.dart';
import 'package:pilll/features/special_offering/page2.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';
import 'package:pilll/provider/remote_config_parameter.dart';

/// 開発者オプション内の行。タップするとスペシャルオファー(年額)Paywallを文言バリアント(default/scarcity)で確認できる。
class SpecialOfferingPaywallRow extends StatelessWidget {
  const SpecialOfferingPaywallRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('スペシャルオファー Paywall(年額)'),
      subtitle: const Text('文言バリアント(default/scarcity)を確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final copyVariant = await _selectSpecialOfferingCopyVariant(context);
        if (copyVariant == null || !context.mounted) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => ProviderScope(
              // 選択した文言バリアントで表示を再現する。価格等の他のProviderはoverrideせずroot側の実データを使う
              overrides: [
                remoteConfigParameterProvider.overrideWithValue(
                  RemoteConfigParameter(specialOfferingCopyVariant: copyVariant.value),
                ),
              ],
              child: SpecialOfferingPage(
                source: PaywallSource.specialOfferingBar,
                specialOfferingIsClosed: ValueNotifier(false),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 開発者オプション内の行。タップするとスペシャルオファー(月額)Paywallを文言バリアント(default/scarcity)で確認できる。
class SpecialOfferingPaywallRow2 extends StatelessWidget {
  const SpecialOfferingPaywallRow2({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('スペシャルオファー Paywall(月額)'),
      subtitle: const Text('文言バリアント(default/scarcity)を確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final copyVariant = await _selectSpecialOfferingCopyVariant(context);
        if (copyVariant == null || !context.mounted) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => ProviderScope(
              overrides: [
                remoteConfigParameterProvider.overrideWithValue(
                  RemoteConfigParameter(specialOfferingCopyVariant: copyVariant.value),
                ),
              ],
              child: SpecialOfferingPage2(
                source: PaywallSource.specialOfferingBar2,
                specialOfferingIsClosed2: ValueNotifier(false),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 表示する文言バリアントを選択するダイアログを表示する。キャンセル時はnullを返す。
Future<SpecialOfferingCopyVariant?> _selectSpecialOfferingCopyVariant(BuildContext context) {
  return showDialog<SpecialOfferingCopyVariant>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('文言バリアントを選択'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(SpecialOfferingCopyVariant.defaultVariant),
          child: const Text('default（現行文言）'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(SpecialOfferingCopyVariant.scarcity),
          child: const Text('scarcity（希少性・限定性訴求）'),
        ),
      ],
    ),
  );
}
