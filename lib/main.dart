import 'package:flutter/material.dart';
import 'package:productos_app/providers/lista_visitas_provider.dart';
import 'package:productos_app/providers/navbar_provider.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/shared/preferences.dart';
import 'package:productos_app/ui/notifications.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<NavbarProvider>(
          create: (context) => NavbarProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(isDarkmode: Preferences.isDarkMode),
        ),
        ChangeNotifierProvider<ModulosProvider>(
          create: (context) => ModulosProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<OrdersProvider>(
          create: (context) => OrdersProvider(),
        ),
        ChangeNotifierProvider<ListaVisitasProvider>(
          create: (context) => ListaVisitasProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Notifications.messengerKey,
      title: 'Material App',
      initialRoute: AuthTokenScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AuthTokenScreen.routeName: (context) => const AuthTokenScreen(),
        CheckInScreen.routeName: (context) => CheckInScreen(),
        CheckOutScreen.routeName: (context) => CheckOutScreen(),
        ModulesScreen.routeName: (context) => ModulesScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        NewVisitScreen.routeName: (context) => NewVisitScreen(),
        VisitDetails.routeName: (context) => VisitDetails(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
