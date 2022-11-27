import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/services.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class VisitDetails extends StatelessWidget {
  static const String routeName = 'visit-details';
  const VisitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final Visitas visita =
        ModalRoute.of(context)?.settings.arguments as Visitas;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Detalle de la Visita'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImagenINE(visita: visita),
                  SizedBox(height: 15),
                  _CustomRichText("ID: ", visita.id.toString(),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                  _CustomRichText("Visitante: ", visita.nombreVisitante,
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                  _CustomRichText("A quien visita: ", visita.nombreAQuienVisita,
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                  _CustomRichText(
                      "Motivo: ",
                      visita.motivoVisita ?? 'No Especificado.',
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                  _CustomRichText("Tipo: ", getTipo(visita.tipoVehiculoId),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                  _CustomRichText("Entrada: ", visita.fechaEntrada, Colors.red),
                  SizedBox(height: 10),
                  if (visita.fechaSalida != '')
                    _CustomRichText(
                        "Salida: ", visita.fechaSalida, Colors.green),
                  if (visita.fechaSalida != '') SizedBox(height: 10),
                  _CustomRichText("Recibió: ", visita.userId.toString(),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText _CustomRichText(String clave, String valor, Color color) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          style: TextStyle(
              fontSize: 20, color: color, fontWeight: FontWeight.bold),
          text: clave,
          children: [
            TextSpan(
              text: valor,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ]),
    );
  }
}

class ImagenINE extends StatelessWidget {
  final Visitas visita;

  const ImagenINE({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          // ignore: sort_child_properties_last
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InteractiveViewer(
              // boundaryMargin: EdgeInsets.all(10),
              minScale: 0.1,
              child: (visita.imagenIdentificacion!.contains('/9j'))
                  ? imageFromBase64String(
                      visita.imagenIdentificacion.toString())
                  : const Image(
                      width: double.infinity,
                      image: AssetImage('assets/imagen01.jpg'),
                    ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
        ),
        const Positioned(
          right: 15,
          bottom: 25,
          child: Icon(
            Icons.aspect_ratio_outlined,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

imageFromBase64String(String base64String) {
  return FadeInImage(
    width: double.infinity,
    height: 400,
    fit: BoxFit.contain,
    image: Image.memory(
      base64Decode(base64String),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.medium,
      alignment: Alignment.center,
    ).image,
    placeholder: const AssetImage('assets/loading.gif'),
  );
}
