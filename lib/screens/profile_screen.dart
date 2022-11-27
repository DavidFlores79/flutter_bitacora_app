import 'package:flutter/material.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/services.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:bitacora_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Mi Perfil'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/user1.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  getCapitalizedString(
                      str: '${apiUser.nombre} ${apiUser.apellido}'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Anton",
                  ),
                ),
                Text(
                  apiUser.miPerfil.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
                const SizedBox(
                  height: 20,
                  child: Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Nickname: ${apiUser.nickname}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
                Text(
                  apiUser.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
                Text(
                  Preferences.expirationDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getCapitalizedString({required String str}) {
  if (str.length <= 1) {
    return str.toUpperCase();
  }
  return '${str[0].toUpperCase()}${str.substring(1)}';
}
