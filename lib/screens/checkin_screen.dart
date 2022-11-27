import 'dart:convert';

import 'package:bitacora_app/ui/notifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class CheckInScreen extends StatefulWidget {
  static const String routeName = 'visitas';

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  @override
  Widget build(BuildContext context) {
    final listaVisitasProvider = Provider.of<ListaVisitasProvider>(context);
    List<Visitas> visitas = listaVisitasProvider.listaDeVisitas;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'Entrada de Visitantes',
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
                                      // setState(() {
                                      //   visitas =
                                      //       listaVisitasProvider.listaDeVisitas;
                                      // });
                                    },
                                    child: const Text("Confirmar")),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
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
                        final altura = MediaQuery.of(context).size.height;
                        Notifications.showSnackBar(
                            'Se ha dado salida a este vehiculo');
                      },
                      child: ListTile(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CustomRichText(
                                "Visitante/Visita: ",
                                "${visitas[index].nombreVisitante} / ${visitas[index].nombreAQuienVisita}",
                                Preferences.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                            _CustomRichText(
                                "Tipo: ",
                                getTipo(visitas[index].tipoVehiculoId),
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

String getfechaSalida() {
  DateTime now = DateTime.now();
  final formatterDate = DateFormat('yyyy-MM-dd HH:mm');
  return formatterDate.format(now).toString();
}
