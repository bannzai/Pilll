import 'package:pilll/provider/auth.dart';
import 'package:riverpod/riverpod.dart';

StreamProvider get refreshAppProvider => firebaseUserStateProvider;
