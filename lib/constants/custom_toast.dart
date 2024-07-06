import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class ToastNotification {
  static void showToast(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
        builder: ((context) => Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            child: _ToastMessage(message: message, type: type))));

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

enum ToastType { normal, positive, error }

class _ToastMessage extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastMessage({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    switch (type) {
      case ToastType.normal:
        backgroundColor = Colors.white;
        break;

      case ToastType.positive:
        backgroundColor = Colors.green;
        break;

      case ToastType.error:
        backgroundColor = Colors.red;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Text(
          message,
          style: TextStyle(
              color: type == ToastType.normal ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
