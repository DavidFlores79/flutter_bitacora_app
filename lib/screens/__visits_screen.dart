import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class VisitsScreen extends StatelessWidget {
  static const String routeName = 'visitas';
  late List<Visitas> visitas;

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      filterQuality: FilterQuality.high,
      width: 44,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaVisitasProvider =
        Provider.of<ListaVisitasProvider>(context, listen: false);
    listaVisitasProvider.listarVisitas();
    visitas = listaVisitasProvider.listaDeVisitas;
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
                                      .eliminarVisitaPorId(visitas[index].id!);
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
                    // setState(() {
                    //   widget.pedidos.removeAt(index);
                    // });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Se ha dado salida a este vehículo')));
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
                            "Tipo: ",
                            getTipo(visitas[index].tipoVehiculoId),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        _CustomRichText(
                            "Placas: ",
                            visitas[index].placas,
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        _CustomRichText("Entrada: ",
                            visitas[index].fechaEntrada, Colors.red),
                        if (visitas[index].fechaSalida != '')
                          _CustomRichText("Salida: ",
                              visitas[index].fechaSalida ?? '', Colors.green),
                        _CustomRichText(
                            "Recibió: ",
                            visitas[index].userId.toString(),
                            Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ],
                    ),
                    leading: const FaIcon(
                      FontAwesomeIcons.car,
                      color: Colors.red,
                    ),
                    trailing: const Icon(Icons.density_small_outlined),
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

String getTipo(int tipoId) {
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
