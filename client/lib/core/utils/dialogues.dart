import 'package:flutter/material.dart';

class Dialogues {
  static void showSuccessDialog(
    BuildContext context,
    String message,
    String title,
    onPressed,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green),
          title: Text(title),
          content: Text(message),
          actions: [TextButton(onPressed: onPressed, child: const Text('OK'))],
        );
      },
    );
  }

  static void showErrorDialog(
    BuildContext context,
    String message,
    String title,
    onPressed,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red),
          title: Text(title),
          content: Text(message),
          actions: [TextButton(onPressed: onPressed, child: const Text('OK'))],
        );
      },
    );
  }
}
