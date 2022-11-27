import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/shared/preferences.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    Key? key,
    required this.pedidos,
    required this.titleSize,
  }) : super(key: key);

  final List<Pedido> pedidos;
  final double titleSize;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Text(
            'Entrada/Salida Visitantes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.pedidos.length,
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
                          '¿Estás seguro que desea dar salida a este Vehículo?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Preferences.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        // content: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: RichText(
                        //     text: TextSpan(
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             color: Preferences.isDarkMode
                        //                 ? Colors.white
                        //                 : Colors.black),
                        //         text:
                        //             "Estas seguro que deseas dar salida a este Vehículo? ",
                        //         children: []),
                        //   ),
                        // ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
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
                    widget.pedidos.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Se ha dado salida a ese vehiculo')));
                },
                child: ListTile(
                  onTap: () {},
                  title: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            color: Preferences.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                        text: "Visita: ",
                        children: const [
                          TextSpan(
                            text:
                                "Eduardo Javier may vera / Suleima baldominos",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CustomRichText("Tipo: ", "Motocicleta",
                          Preferences.isDarkMode ? Colors.white : Colors.black),
                      _CustomRichText("Entrada: ", "10:25 AM", Colors.red),
                      _CustomRichText("Salida: ", "14:03 PM", Colors.green),
                    ],
                  ),
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child:
                        Image.asset('assets/placa.jpg', fit: BoxFit.fitWidth),
                  ),
                  trailing: Icon(Icons.density_small_outlined),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ],
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

String numberFormatDlls(double numero) {
  NumberFormat f = NumberFormat("USD\$###,###,###.0##", "es_US");
  String result = f.format(numero);
  return result;
}

String numberFormat(double numero) {
  NumberFormat f = NumberFormat("\$###,###,###.0##", "es_MX");
  String result = f.format(numero);
  return result;
}
