import 'dart:math';

import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/services/services.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitacora_app/providers/navbar_provider.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/auth_service.dart';
import 'package:bitacora_app/ui/notifications.dart';
import 'package:bitacora_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'inicio';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(
      context,
      listen: false,
    );
    final mp = Provider.of<NavbarProvider>(context);
    final listaVisitasProvider = Provider.of<ListaVisitasProvider>(
      context,
      listen: false,
    );
    Preferences.screenHeigth = MediaQuery.of(context).size.height - 300;
    // listaVisitasProvider.listarVisitas();
    listaVisitasProvider.listarVisitasNoSincronizadas();
    // listaVisitasProvider.eliminarTodasLasVisitas();
    FloatingActionButton floatingActionButton = FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, NewVisitScreen.routeName);
      },
      // child: const Icon(Icons.receipt_outlined),
      child: const FaIcon(
        FontAwesomeIcons.car,
      ),
    );
    switch (mp.items[mp.selectedIndex].ruta) {
      case CheckOutScreen.routeName:
        floatingActionButton = FloatingActionButton(
            child: const Icon(Icons.sync),
            onPressed: () {
              final syncService =
                  Provider.of<SyncService>(context, listen: false);
              List<Visitas> visitas = listaVisitasProvider.listaDeVisitas;
              syncService.sincronizarVisitas(visitas);
              visitas = listaVisitasProvider.listaDeVisitas;
              Notifications.showSnackBar('Sincronizando datos...',
                  screenHeight: Preferences.screenHeigth);
            });
        break;
      case AboutScreen.routeName:
        floatingActionButton = FloatingActionButton(
          child: const FaIcon(
            FontAwesomeIcons.gear,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, SettingsScreen.routeName),
        );
        break;
      default:
        floatingActionButton = FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, NewVisitScreen.routeName);
          },
          // child: const Icon(Icons.receipt_outlined),
          child: const FaIcon(
            FontAwesomeIcons.car,
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Image(
          image: AssetImage('assets/hope-logo.png'),
          height: 45,
        ),
        actions: const [
          PopupMenuList(),
        ],
      ),
      body: mp.items[mp.selectedIndex].widget,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

randomNumber(int min, int max) {
  return min + Random().nextInt(max - min);
}
