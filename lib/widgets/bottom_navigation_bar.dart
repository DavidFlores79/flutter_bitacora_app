import 'package:flutter/material.dart';
import 'package:productos_app/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return BottomNavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: mp.selectedIndex,
        onTap: (value) {
          mp.selectedIndex = value;
        },
        items: mp.items
            .map((e) => BottomNavigationBarItem(
                  label: e.label,
                  icon: e.iconData!,
                ))
            .toList());
  }
}
