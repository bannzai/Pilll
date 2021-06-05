import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumIntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: Center(
        child: FutureBuilder(
          future: _offers(),
          builder: (context, value) {
            if (value.hasError) {
              showErrorAlert(context, message: value.error.toString());
              return Indicator();
            }
            if (!value.hasData) {
              return Indicator();
            }
            final data = value.data;
            if (data is List) {
              if (data.isEmpty) {
                return Container(child: Text("data is empty"));
              }
              if (data is List<Package>) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((e) {
                      return GestureDetector(
                        onTap: () async {
                          await _purchase(e);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("identifier: ${e.identifier}"),
                            Text("offeringIdentifier: ${e.offeringIdentifier}"),
                            Text("packageType: ${e.packageType}"),
                            Text("product: ${e.product}"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            }
            throw AssertionError(
                "unexpected type ${data.runtimeType}, data: $data");
          },
        ),
      ),
    );
  }

  Future<void> _purchase(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      var isPro = purchaserInfo.entitlements.all["Premium"]?.isActive;
      print(isPro);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
        print(errorCode);
      }
      rethrow;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Package>> _offers() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      if (currentOffering != null) {
        return currentOffering.availablePackages;
      }
      return [];
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      print(exception);
      rethrow;
    }
  }
}

extension PremiumIntroductionPageRoutes on PremiumIntroductionPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PremiumIntroductionPage"),
      builder: (_) => PremiumIntroductionPage(),
    );
  }
}
