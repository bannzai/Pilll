import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/root/launch_exception.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/template.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/user.dart';
import 'package:flutter/material.dart';

// Userの作成・もしくは取得を行い次のWidgetに渡す
class UserSetup extends HookConsumerWidget {
  final String userID;
  final Widget Function(BuildContext) builder;
  const UserSetup({
    Key? key,
    required this.userID,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setUserID = ref.watch(setUserIDProvider);
    final fetchOrCreateUser = ref.watch(fetchOrCreateUserProvider);
    final saveUserLaunchInfo = ref.watch(saveUserLaunchInfoProvider);

    final appUser = useState<User?>(null);
    final error = useState<LaunchException?>(null);

    // Setup user
    useEffect(() {
      void f() async {
        // **** BEGIN: Do not break the sequence. ****
        try {
          // Decide screen type. Keep in mind that this method is called when user is logged in.
          final appUserValue = appUser.value;
          if (appUserValue == null) {
            // Retrieve user from app DB.
            final user = await fetchOrCreateUser(userID);
            appUser.value = user;

            // Register userID for each analytics libraries.
            setUserID(userID: userID);
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException("起動時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
        }
        // **** END: Do not break the sequence. ****
      }

      f();
      return null;
    }, []);

    useEffect(() {
      final appUserValue = appUser.value;
      if (appUserValue != null) {
        saveUserLaunchInfo(appUserValue);
      }
      return null;
    }, [appUser.value]);

    return UniversalErrorPage(
      error: error.value,
      reload: () => ref.refresh(refreshAppProvider),
      child: () {
        final appUserValue = appUser.value;
        if (appUserValue == null) {
          return const ScaffoldIndicator();
        } else {
          return builder(context);
        }
      }(),
    );
  }
}
