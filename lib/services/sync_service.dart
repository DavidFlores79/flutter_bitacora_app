import 'dart:convert';

import 'package:bitacora_app/locator.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/db_provider.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/services.dart';
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

  final NavigationService _navigationService = locator<NavigationService>();
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
    late SyncResponse serverResponse;

    try {
      final response = await http.post(url,
          headers: headers, body: jsonEncode(dataRaw.toMap()));

      // final Map<String, dynamic> decodedResp = json.decode(response.body);
      // print(decodedResp);

      switch (response.statusCode) {
        case 200:
          serverResponse = SyncResponse.fromJson(response.body);
          print('soy un 200: ${serverResponse.toJson()}');

          Notifications.messengerKey.currentState!.hideCurrentSnackBar();
          Notifications.showSnackBar((serverResponse.visitasActualizadas != 0)
              ? serverResponse.message
              : "No existen registros por actualizar");
          if (serverResponse.visitasActualizadas != 0) {
            for (var i = 0; i < serverResponse.idsActualizados!.length; i++) {
              print(serverResponse.idsActualizados?[i]);
              DBProvider.db.deleteRecord(serverResponse.idsActualizados![i]);
            }
          }
          break;
        case 401:
          print('logout');
          logout();
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
          serverResponse = SyncResponse.fromJson(response.body);
          print('soy un 500: ${serverResponse.toJson()}');
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

  logout() async {
    await storage.deleteAll();
    Notifications.messengerKey.currentState!.hideCurrentSnackBar();
    Notifications.showSnackBar('Su sesión ha vencido.');
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
