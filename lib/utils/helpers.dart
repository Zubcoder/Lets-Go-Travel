import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelpers {
  static String formatDate(DateTime date, String locale) {
    return DateFormat('d MMMM yyyy', locale).format(date);
  }

  static String formatPrice(double price, {String currency = '₽'}) {
    final formatter = NumberFormat('#,##0', 'ru');
    return '${formatter.format(price)} $currency';
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
