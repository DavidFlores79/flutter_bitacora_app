import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/shared/preferences.dart';
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
        title: const Text('Detalles de la Visita'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                await authService.logout();
              },
              icon: const Icon(Icons.logout))
        ],
        //backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
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
                  (visita.imagenIdentificacion!.contains('/9j'))
                      ? imageFromBase64String(
                          visita.imagenIdentificacion.toString())
                      : const Image(
                          width: double.infinity,
                          image: AssetImage('assets/imagen01.jpg'),
                        ),
                  _CustomRichText("ID: ", visita.id.toString(),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText("Visitante: ", visita.nombreVisitante,
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText("A quien visita: ", visita.nombreAQuienVisita,
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText(
                      "Motivo: ",
                      visita.motivoVisita ?? 'No Especificado.',
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText("Tipo: ", getTipo(visita.tipoVehiculoId),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText("Entrada: ", visita.fechaEntrada, Colors.red),
                  if (visita.fechaSalida != '')
                    _CustomRichText(
                        "Salida: ", visita.fechaSalida, Colors.green),
                  _CustomRichText("Recibió: ", visita.userId.toString(),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
                  _CustomRichText(
                      "Actualizado: ",
                      visita.actualizado.toString(),
                      Preferences.isDarkMode ? Colors.white : Colors.black),
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
      textAlign: TextAlign.justify,
      text: TextSpan(
          style: TextStyle(
              fontSize: 25, color: color, fontWeight: FontWeight.bold),
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

imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String),
    width: 300,
    height: 300,
    fit: BoxFit.fill,
    filterQuality: FilterQuality.high,
    alignment: Alignment.center,
  );
}
