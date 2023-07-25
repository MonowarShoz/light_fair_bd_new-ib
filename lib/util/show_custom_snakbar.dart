import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 3000),
      content: Text(message, textAlign: TextAlign.center, style: robotoRegular),
      backgroundColor: isError ? Colors.red.shade700 : Colors.green,
      elevation: 6.0,
      margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
    ),
  );
}
