// To parse this JSON data, do
//
//     final visitas = visitasFromMap(jsonString);

import 'dart:convert';

class Visitas {
  Visitas({
    this.id,
    required this.nombreVisitante,
    required this.nombreAQuienVisita,
    this.motivoVisita,
    this.imagenIdentificacion,
    required this.tipoVehiculoId,
    required this.placas,
    required this.userId,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.actualizado,
  });

  int? id;
  String nombreVisitante;
  String nombreAQuienVisita;
  String? motivoVisita;
  String? imagenIdentificacion;
  int tipoVehiculoId;
  String placas;
  int userId;
  String fechaEntrada;
  String fechaSalida;
  int actualizado;

  factory Visitas.fromJson(String str) => Visitas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Visitas.fromMap(Map<String, dynamic> json) => Visitas(
        id: json["id"],
        nombreVisitante: json["nombreVisitante"],
        nombreAQuienVisita: json["nombreAQuienVisita"],
        motivoVisita: json["motivoVisita"],
        imagenIdentificacion: json["imagenIdentificacion"],
        tipoVehiculoId: json["tipoVehiculoId"],
        placas: json["placas"],
        userId: json["userId"],
        fechaEntrada: json["fechaEntrada"],
        fechaSalida: json["fechaSalida"],
        actualizado: json["actualizado"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombreVisitante": nombreVisitante,
        "nombreAQuienVisita": nombreAQuienVisita,
        "motivoVisita": motivoVisita,
        "imagenIdentificacion": imagenIdentificacion,
        "tipoVehiculoId": tipoVehiculoId,
        "placas": placas,
        "userId": userId,
        "fechaEntrada": fechaEntrada,
        "fechaSalida": fechaSalida,
        "actualizado": actualizado,
      };
}
