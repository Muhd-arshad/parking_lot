import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    message: message,
    duration: duration,
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: Colors.black,
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white, // Set text color to white
        // Set your desired font size
      ),
      textAlign: TextAlign.center, // Center-align the text
    ),
  ).show(context);
}