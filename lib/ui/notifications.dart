import 'package:flutter/material.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message, {double screenHeight = 0}) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(
          bottom: screenHeight,
          left: 20,
          right: 20,
        ),
        backgroundColor: const Color.fromRGBO(240, 171, 0, 1),
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
