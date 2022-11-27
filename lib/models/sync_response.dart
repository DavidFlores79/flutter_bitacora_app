/// Creado por: David Amilcar Flores Castillo
/// el 22/11/2022

import 'dart:convert';

class SyncResponse {
  SyncResponse({
    required this.code,
    required this.status,
    required this.success,
    required this.message,
    this.visitasActualizadas,
    this.idsActualizados,
  });

  int code;
  String status;
  bool success;
  String message;
  int? visitasActualizadas;
  List<int>? idsActualizados;

  factory SyncResponse.fromJson(String str) =>
      SyncResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SyncResponse.fromMap(Map<String, dynamic> json) => SyncResponse(
        code: json["code"],
        status: json["status"],
        success: json["success"],
        message: json["message"],
        visitasActualizadas: json["visitas_actualizadas"],
        idsActualizados: List<int>.from(json["ids_actualizados"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "success": success,
        "message": message,
        "visitas_actualizadas": visitasActualizadas,
        "ids_actualizados": List<dynamic>.from(idsActualizados!.map((x) => x)),
      };
}
