/// Creado por: David Amilcar Flores Castillo
/// el 22/11/2022

import 'dart:convert';

import 'package:bitacora_app/models/models.dart';

class ListaVisitasRequest {
  ListaVisitasRequest({
    required this.visitas,
  });

  List<Visitas> visitas;

  factory ListaVisitasRequest.fromJson(String str) =>
      ListaVisitasRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListaVisitasRequest.fromMap(Map<String, dynamic> json) =>
      ListaVisitasRequest(
        visitas:
            List<Visitas>.from(json["visitas"].map((x) => Visitas.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "visitas": List<dynamic>.from(visitas.map((x) => x.toMap())),
      };
}
