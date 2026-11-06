import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/root/launch_exception.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/template.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/user.dart';
import 'package:flutter/material.dart';

// Userの作成・もしくは取得を行い次のWidgetに渡す
class UserSetup extends HookConsumerWidget {
  final String userID;
  final Widget Function(BuildContext) builder;
  const UserSetup({super.key, required this.userID, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setUserID = ref.watch(setUserIDProvider);
    final fetchOrCreateUser = ref.watch(fetchOrCreateUserProvider);
    final saveUserLaunchInfo = ref.watch(saveUserLaunchInfoProvider);

    final appUser = useState<User?>(null);
    final error = useState<LaunchException?>(null);

    // Setup user
    // 初期設定のログインで別のアカウントに切り替わると userID が変わる。RevenueCat のユーザーと CustomerInfo もそのアカウントのものに切り替えるため、userID ごとにやり直す
    useEffect(() {
      void f() async {
        // **** BEGIN: Do not break the sequence. ****
        try {
          // Decide screen type. Keep in mind that this method is called when user is logged in.
          // Retrieve user from app DB.
          final user = await fetchOrCreateUser(userID);

          // Register userID for each analytics libraries.
          // customerInfoProvider は RevenueCat SDK の設定 (切り替えでは logIn) の後にしか読めないため、待ってから次の Widget を出す
          await setUserID(userID: userID);
          // 前のアカウントの CustomerInfo を持ち越さない
          ref.invalidate(customerInfoProvider);
          appUser.value = user;
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException(
            L.launchError(ErrorMessages.connection),
            e,
          );
        }
        // **** END: Do not break the sequence. ****
      }

      f();
      return null;
    }, [userID]);

    useEffect(() {
      final appUserValue = appUser.value;
      if (appUserValue != null) {
        saveUserLaunchInfo(appUserValue);
      }
      return null;
    }, [appUser.value]);

    // プレミアム・トライアルの判定 (CustomerInfoPremium) を画面が requireValue で読めるよう、CustomerInfo の取得後にだけ次の Widget を出す。
    // 取得し直し (ref.invalidate) の間は前の値で表示を続ける
    final customerInfo = appUser.value == null ? null : ref.watch(customerInfoProvider);
    final customerInfoError = customerInfo?.error;
    return UniversalErrorPage(
      error: error.value ??
          (customerInfo != null && !customerInfo.hasValue && customerInfoError != null
              ? LaunchException(L.launchError(ErrorMessages.connection), customerInfoError)
              : null),
      reload: () {
        ref.invalidate(customerInfoProvider);
        ref.invalidate(refreshAppProvider);
      },
      child: () {
        if (customerInfo == null || !customerInfo.hasValue) {
          return const ScaffoldIndicator();
        } else {
          return builder(context);
        }
      }(),
    );
  }
}
