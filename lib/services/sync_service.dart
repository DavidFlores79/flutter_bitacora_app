import 'dart:convert';

import 'package:bitacora_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bitacora_app/ui/notifications.dart';

class SyncService extends ChangeNotifier {
  final String _apiUrl = '192.168.100.8';
  final String _proyectName = '/bitacora/public_html';
  String _endPoint = '/api/v1/sync';
  String jwtToken = '';
  List<Visitas> visitas = [];
  bool result = false;

  final storage = const FlutterSecureStorage();

  Future<String?> sincronizarVisitas(List<Visitas> visitas) async {
    _endPoint = '/api/v1/sync';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    //print('Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    ListaVisitasRequest dataRaw = ListaVisitasRequest(visitas: visitas);

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http.post(url,
          headers: headers, body: jsonEncode(dataRaw.toMap()));

      final Map<String, dynamic> decodedResp = json.decode(response.body);
      print(decodedResp);

      switch (response.statusCode) {
        case 200:
          print('soy un 200');
          break;
        case 401:
          print('logout');
          // if (response.body.contains('code')) {
          //   serverResponse = ServerResponse.fromJson(response.body);
          //   Notifications.showSnackBar(
          //       serverResponse?.message ?? 'Error de Autenticación.');
          // } else {
          //   logout();
          //   print('logout');
          // }
          break;
        case 404:
          // serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error Desconocido.');
          // pedidos = [];
          // pedidosXProv = [];
          // notifyListeners();
          // print(serverResponse);
          print('soy un 404');
          break;
        case 500:
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print(response.body);
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      Notifications.showSnackBar(e.toString());
    }

    //print(decodedResp);
  }

  Future<String> getToken() async {
    return await storage.read(key: 'jwtToken') ?? '';
  }
}