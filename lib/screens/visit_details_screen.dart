import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        title: const Text('Detalle de la Visita'),
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
          height: 300,
          // ignore: sort_child_properties_last
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InteractiveViewer(
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
                color: Colors.grey.shade600,
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(-3, 3), // changes position of shadow
              ),
            ],
          ),
        ),
        const Positioned(
          right: 15,
          bottom: 15,
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
    fit: BoxFit.cover,
    image: Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
      filterQuality: FilterQuality.medium,
      alignment: Alignment.center,
    ).image,
    placeholder: const AssetImage('assets/loading.gif'),
  );
}
