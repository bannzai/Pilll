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
    // user・RevenueCat のユーザー・CustomerInfo の用意を終えた userID。userID と一致する間だけ次の Widget を出す
    final setupCompletedUserID = useState<String?>(null);
    // 再読み込みで用意をやり直すための回数
    final setupAttempt = useState(0);

    // Setup user
    // 初期設定のログインで別のアカウントに切り替わると userID が変わる。RevenueCat のユーザーと CustomerInfo もそのアカウントのものに切り替えるため、userID ごとにやり直す。
    // やり直している間は setupCompletedUserID が userID と一致しないため、前のアカウントの user・CustomerInfo で画面を出さない
    useEffect(() {
      var isCancelled = false;
      void f() async {
        error.value = null;
        // **** BEGIN: Do not break the sequence. ****
        try {
          // Decide screen type. Keep in mind that this method is called when user is logged in.
          // Retrieve user from app DB.
          final user = await fetchOrCreateUser(userID);

          // Register userID for each analytics libraries.
          // customerInfoProvider は RevenueCat SDK の設定 (切り替えでは logIn) の後にしか読めないため、待ってから次の Widget を出す
          await setUserID(userID: userID);
          // 前のアカウントの CustomerInfo を持ち越さないよう取得し直し、取得を終えてから次の Widget を出す
          ref.invalidate(customerInfoProvider);
          await ref.read(customerInfoProvider.future);
          if (isCancelled) {
            return;
          }
          appUser.value = user;
          setupCompletedUserID.value = userID;
        } catch (e, st) {
          errorLogger.recordError(e, st);
          if (isCancelled) {
            return;
          }
          error.value = LaunchException(
            L.launchError(ErrorMessages.connection),
            e,
          );
        }
        // **** END: Do not break the sequence. ****
      }

      f();
      // 用意の途中で userID が変わった時は、古い userID の結果で状態を上書きしない
      return () => isCancelled = true;
    }, [userID, setupAttempt.value]);

    useEffect(() {
      final appUserValue = appUser.value;
      if (appUserValue != null) {
        saveUserLaunchInfo(appUserValue);
      }
      return null;
    }, [appUser.value]);

    // プレミアム・トライアルの判定 (CustomerInfoPremium) を画面が requireValue で読めるよう、CustomerInfo の取得後にだけ次の Widget を出す。
    // 用意を終えた後の取得し直し (トライアルの付与後の ref.invalidate) の間は、同じユーザーの前の値で表示を続ける
    return UniversalErrorPage(
      error: error.value,
      reload: () {
        ref.invalidate(refreshAppProvider);
        setupAttempt.value++;
      },
      child: setupCompletedUserID.value == userID ? builder(context) : const ScaffoldIndicator(),
    );
  }
}
