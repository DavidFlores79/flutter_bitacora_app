import 'package:bitacora_app/locator.dart';
import 'package:bitacora_app/services/services.dart';
import 'package:bitacora_app/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:bitacora_app/providers/lista_visitas_provider.dart';
import 'package:bitacora_app/providers/navbar_provider.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/auth_service.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:bitacora_app/ui/notifications.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  setupLocator();
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
        ChangeNotifierProvider<SyncService>(
          create: (context) => SyncService(),
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
      navigatorKey: locator<NavigationService>().navigatorKey,
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
        ProfileScreen.routeName: (context) => ProfileScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
