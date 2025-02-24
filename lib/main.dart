import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:examen_final_mendoza/screens/screens.dart';
import 'package:examen_final_mendoza/services/services.dart';
import 'package:examen_final_mendoza/providers/providers.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
  );

  // Inicializar Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity, // Para Android
  );

  final prefs = await SharedPreferences.getInstance();
  final bool rememberMe = prefs.getBool('rememberMe') ?? false;
  final String? email = prefs.getString('email');
  final String? password = prefs.getString('password');

  runApp(MyApp(
    startScreen: (rememberMe && email != null && password != null)
        ? HomeScreen() 
        : LoginOrRegisterScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonService()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Users App',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (context) => startScreen,
          'home': (context) => HomeScreen(),
          'logOrReg': (context) => LoginOrRegisterScreen(),
          'detail': (_) => DetailScreen(),
          'mapa' : (_) => MapaScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}