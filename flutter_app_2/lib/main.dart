import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/home_page.dart';

import 'package:flutter_app_2/pages/login_page.dart';
import 'package:flutter_app_2/pages/register_page.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';



void main() async {
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: prefs.getPagina(),
      routes: {
        HomePage.routeName : ( BuildContext context ) => HomePage(),
        LoginPage.routeName : ( BuildContext context ) => LoginPage(),
        RegisterPage.routeName : ( BuildContext context ) => RegisterPage(),
      },
    );
  }
}

