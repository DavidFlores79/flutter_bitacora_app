import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bitacora_app/ui/notifications.dart';

class AuthService extends ChangeNotifier {
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = '';
  final storage = const FlutterSecureStorage();

  Future<String?> loginUser(String nickname, String password) async {
    final Map<String, dynamic> authData = {
      'nickname': nickname,
      'password': password
    };

    final url = Uri.https(_apiUrl, '/api/login', authData);
    print(url);
    try {
      final response = await http
          .post(url, body: json.encode(authData))
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> decodedResp = json.decode(response.body);
      print(decodedResp);
      //print('decodedResp = ${decodedResp['success']}');

      if (decodedResp['code'] == 200) {
        //guardar el token y la info del usuario
        await storage.write(key: 'jwtToken', value: decodedResp['jwt']);
        Preferences.apiUser = jsonEncode(decodedResp['user']);
        Preferences.expirationDate =
            Preferences.timestampToDate(decodedResp['exp']);
        return true.toString();
      } else {
        return decodedResp['message'] ?? "Servidor no disponible.";
      }
    } catch (e) {
      Notifications.showSnackBar('Error: ${e.toString()}',
          screenHeight: Preferences.screenHeigth);
    }

    //print(decodedResp);
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    notifyListeners();
    return;
  }

  Future<String> getToken() async {
    final DateTime expirationDate = DateTime.parse(Preferences.expirationDate);
    final DateTime now = DateTime.now();
    if (now.compareTo(expirationDate) > 0) {
      Preferences.apiUser = '';
      return '';
    }
    return await storage.read(key: 'jwtToken') ?? '';
  }
}
