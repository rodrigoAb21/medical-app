import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/home_medico.dart';
import 'package:flutter_app_2/pages/home_usuario.dart';
import 'package:flutter_app_2/pages/lista_medicos.dart';

import 'package:flutter_app_2/pages/login_page.dart';
import 'package:flutter_app_2/pages/register_usuario.dart';
import 'package:flutter_app_2/pages/register_medico.dart';
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
        HomeUsuarioPage.routeName : ( BuildContext context ) => HomeUsuarioPage(),
        HomeMedicoPage.routeName : ( BuildContext context ) => HomeMedicoPage(),
        LoginPage.routeName : ( BuildContext context ) => LoginPage(),
        RegisterUsuarioPage.routeName : ( BuildContext context ) => RegisterUsuarioPage(),
        RegisterMedicoPage.routeName : ( BuildContext context ) => RegisterMedicoPage(),
        ListaMedicosPage.routeName : ( BuildContext context ) => ListaMedicosPage(),
      },
    );
  }
}

