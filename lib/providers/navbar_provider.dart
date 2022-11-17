import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/screens/screens.dart';

class NavbarProvider extends ChangeNotifier {
  List<NavbarDTO> items = [
    NavbarDTO(
      label: 'Registros',
      iconData: const FaIcon(FontAwesomeIcons.newspaper),
      widget: OrdersScreen(),
    ),
    NavbarDTO(
      label: 'Acerca de',
      iconData: const FaIcon(FontAwesomeIcons.question),
      widget: AboutScreen(),
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

  NavbarDTO({this.widget, this.label, this.iconData});
}
