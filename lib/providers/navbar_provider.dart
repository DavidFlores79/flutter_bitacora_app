import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/screens/screens.dart';

class NavbarProvider extends ChangeNotifier {
  List<NavbarDTO> items = [
    NavbarDTO(
        label: 'Entradas',
        iconData: const FaIcon(FontAwesomeIcons.car),
        widget: CheckInScreen(),
        ruta: CheckInScreen.routeName),
    NavbarDTO(
      label: 'Salidas',
      iconData: const FaIcon(FontAwesomeIcons.carRear),
      widget: CheckOutScreen(),
      ruta: CheckOutScreen.routeName,
    ),
    NavbarDTO(
      label: 'Acerca de',
      iconData: const FaIcon(FontAwesomeIcons.question),
      widget: AboutScreen(),
      ruta: AboutScreen.routeName,
    ),
  ];

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}

class NavbarDTO {
  Widget? widget;
  String? label;
  Widget? iconData;
  String? ruta;

  NavbarDTO({this.widget, this.label, this.iconData, this.ruta});
}
