import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _overlayEntry;

  static void showSuccessToast(BuildContext context, String message) {
    _showToast(
      context,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    _showToast(
      context,
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void _showToast(BuildContext context, String message,
      {required Color backgroundColor, required Color textColor}) {
    // Remove toast anterior, se houver
    _removeExistingToast();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Posição na parte inferior, considerando o padding inferior
        bottom: MediaQuery.of(context).padding.bottom + 10,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Remover o toast após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      _removeExistingToast();
    });
  }

  static void _removeExistingToast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
