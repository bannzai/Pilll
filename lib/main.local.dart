import 'package:Pilll/entrypoint.dart';
import 'package:Pilll/util/environment.dart';

Future<void> main() async {
  Environment.flavor = Flavor.LOCAL;
  await entrypoint();
}
