import 'package:flutter/material.dart';

class ModalsHelper {
  static void snackbar(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: backgroundColor,
          content: Text(
            message,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          )),
    );
  }
}
