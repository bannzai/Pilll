import 'package:pilll/entrypoint.dart';
import 'package:pilll/util/environment.dart';

Future<void> main() async {
  Environment.flavor = Flavor.DEVELOP;
  await entrypoint();
}
