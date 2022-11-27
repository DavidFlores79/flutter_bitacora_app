import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/shared/preferences.dart';
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
    listaVisitasProvider.listarVisitasSincronizadas();
    List<Visitas> visitas = listaVisitasProvider.listaDeVisitas;
    visitas.map(
      (visita) {
        return visita.fechaEntrada != '';
      },
    );
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Salidas Registradas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: visitas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, VisitDetails.routeName,
                        arguments: visitas[index]);
                  },
                  title: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            color: Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                        text: "# ",
                        children: [
                          TextSpan(
                            text: "${visitas[index].id}",
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CustomRichText(
                          "Visitante/Visita: ",
                          "${visitas[index].nombreVisitante} / ${visitas[index].nombreAQuienVisita}",
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                      _CustomRichText(
                          "Tipo: ",
                          getTipo(visitas[index].tipoVehiculoId),
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                      _CustomRichText(
                          "Recibió: ",
                          visitas[index].userId.toString(),
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                      _CustomRichText(
                          "Entrada: ", visitas[index].fechaEntrada, Colors.red),
                      if (visitas[index].fechaSalida != '')
                        _CustomRichText("Salida: ", visitas[index].fechaSalida,
                            Colors.green),
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
