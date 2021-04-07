import 'package:flutter/material.dart';

class ModalsHelper {
  static Future<void> snackbar(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) async {
    await ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: backgroundColor,
              duration: Duration(seconds: 1),
              content: Text(
                message,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
        )
        .closed;
  }
}
