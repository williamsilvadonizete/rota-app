import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showSuccessToast(String message) {
    _showToast(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static void showErrorToast(String message) {
    _showToast(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void _showToast(String message,
      {required Color backgroundColor, required Color textColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG, // Aumentado para garantir no mínimo 3 segundos
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
      webBgColor: backgroundColor.toString(),
      webPosition: 'bottom',
    );
  }
}
