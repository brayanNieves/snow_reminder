import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtil{
  static void showSnackBar(BuildContext context, String message,
      {Color? color, int duration = 3000}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: duration),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
      ),
    ));
  }
}