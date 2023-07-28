import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String currencySymbol(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencySymbol;
}

String removeZero(double price) {
  var priceString = price.toString();

  if (price.toString().split(".").isNotEmpty) {
    var decmialPoint = price.toString().split(".")[1];
    if (decmialPoint == "0") {
      priceString = priceString.split(".0").join("");
    }
    if (decmialPoint == "00") {
      priceString = priceString.split(".00").join("");
    }
  }

  return priceString;
}
