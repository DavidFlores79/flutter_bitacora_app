import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class NewVisitScreen extends StatelessWidget {
  static const String routeName = 'newvisit';

  const NewVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Nueva Visita'),
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
            child: Column(
              children: const [
                Center(
                  child: Text('Hola mundo!'),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.floppyDisk),
        onPressed: () {
          const nombreVisitante = "David Flores";
          const nombreAQuienVisita = "Glendy Perez";
          const motivoVisita = "Rappy";
          const imagenIdentificacion = "placa2.png";
          final tipoVehiculoId = randomNumber(1, 4);
          const placas = "FYX-5689";
          final userId = randomNumber(1, 3);
          const fechaEntrada = "17-11-2022 10:03 PM";
          const fechaSalida = "";
          const actualizado = 0;

          Provider.of<ListaVisitasProvider>(context, listen: false)
              .agregarVisita(
            nombreVisitante,
            nombreAQuienVisita,
            motivoVisita,
            fechaEntrada,
            fechaSalida,
            imagenIdentificacion,
            placas,
            tipoVehiculoId,
            userId,
            actualizado,
          );

          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      ),
    );
  }
}
