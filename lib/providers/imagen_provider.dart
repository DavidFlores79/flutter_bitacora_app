// import 'package:flutter/material.dart';
// import 'package:bitacora_app/shared/preferences.dart';

// class ImagenProvider extends ChangeNotifier {
//   static String base64String = "";

//   ImagenProvider() {
//     print('Imagen provider inicializado');
//     mostrarImagen();
//   }

//   guardarImagen(String value) async {
//     Preferences.IMG_KEY = value;
//     base64String = value;
//     notifyListeners();
//   }

//   mostrarImagen() async {
//     base64String = Preferences.IMG_KEY;
//     notifyListeners();
//   }
// }
