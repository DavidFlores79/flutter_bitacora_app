import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  static const String routeName = 'salidas';

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    final listaVisitasProvider = Provider.of<ListaVisitasProvider>(context);
    List<Visitas> visitas = listaVisitasProvider.listaDeVisitas;
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Entrada/Salida Visitantes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: visitas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 25),
                    child: const FaIcon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar Salida",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          content: Text(
                            '¿Estás seguro que desea dar salida a este Vehículo? \n\n Placas: ${visitas[index].placas}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Preferences.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  Provider.of<ListaVisitasProvider>(context,
                                          listen: false)
                                      .actualizarSalida(visitas[index].id!);
                                  visitas = listaVisitasProvider.listaDeVisitas;
                                },
                                child: const Text("Confirmar")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      visitas.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Se ha dado salida a este vehiculo')));
                  },
                  child: ListTile(
                    onTap: () {
                      print('abrir algo');
                    },
                    title: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 15,
                              color: Preferences.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                          text: "Visita: ",
                          children: [
                            TextSpan(
                              text:
                                  "${visitas[index].nombreVisitante} / ${visitas[index].nombreAQuienVisita}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                          ]),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CustomRichText(
                            "ID: ",
                            visitas[index].id.toString(),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        _CustomRichText(
                            "Tipo: ",
                            _getTipo(visitas[index].tipoVehiculoId),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        _CustomRichText("Entrada: ",
                            visitas[index].fechaEntrada, Colors.red),
                        if (visitas[index].fechaSalida != '')
                          _CustomRichText("Salida: ",
                              visitas[index].fechaSalida, Colors.green),
                        _CustomRichText(
                            "Recibió: ",
                            visitas[index].userId.toString(),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        _CustomRichText(
                            "Actualizado: ",
                            visitas[index].actualizado.toString(),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ],
                    ),
                    leading: FaIcon(
                      FontAwesomeIcons.car,
                      size: 30,
                      color: (visitas[index].actualizado == 1)
                          ? Colors.green
                          : Colors.red,
                    ),
                    // trailing: const FaIcon(FontAwesomeIcons.circleQuestion),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  RichText _CustomRichText(String clave, String valor, Color color) {
    return RichText(
      text: TextSpan(
          style: TextStyle(
              fontSize: 15, color: color, fontWeight: FontWeight.bold),
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

String _getTipo(int tipoId) {
  String tipo = 'Desconocido';
  switch (tipoId) {
    case 1:
      tipo = 'Vehículo';
      break;
    case 2:
      tipo = 'Motocicleta';
      break;
    case 3:
      tipo = 'Camión';
      break;
    default:
  }
  return tipo;
}

_imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String),
    fit: BoxFit.fill,
  );
}