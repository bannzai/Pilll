import 'package:pilll/native/channel.dart';

void requestAppTrackingTransparency() {
  methodChannel.invokeMethod('requestAppTrackingTransparency');
}
