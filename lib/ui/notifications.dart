import 'package:bitacora_app/shared/preferences.dart';
import 'package:flutter/material.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final screenHeight = Preferences.screenHeigth;

    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(
          bottom: screenHeight - 320,
          left: 20,
          right: 20,
        ),
        backgroundColor: const Color.fromRGBO(240, 171, 0, 1),
        content: Text(
          '${message} ${screenHeight}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
