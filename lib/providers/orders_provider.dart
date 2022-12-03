import 'package:bitacora_app/shared/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bitacora_app/models/error_response.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/ui/notifications.dart';

class OrdersProvider extends ChangeNotifier {
  final String _apiUrl = Preferences.apiServer;
  final String _endPoint = '/api/v1/ordenes-pendientes';
  String jwtToken = '';
  List<Pedido> pedidos = [];
  ErrorResponse? errorResponse;

  final storage = const FlutterSecureStorage();

  OrdersProvider() {
    //print('Ordenes provider inicializado');
    getOrdenes();
  }

  getOrdenes() async {
    //print('listado de Ordenes');

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.https(_apiUrl, _endPoint);

    final response = await http.post(url, headers: headers);

    switch (response.statusCode) {
      case 200:
        final ordersResponse = OrderResponse.fromJson(response.body);
        pedidos.addAll(ordersResponse.pedidos);
        //print(pedidos);
        break;
      case 401:
        logout();
        break;
      case 404:
        errorResponse = ErrorResponse.fromJson(response.body);
        Notifications.showSnackBar(errorResponse!.message);
        notifyListeners();
        //print(errorResponse);
        break;
      default:
      //print(response.body);
    }
    notifyListeners();
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    notifyListeners();
    return;
  }
}
