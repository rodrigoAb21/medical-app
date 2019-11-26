import 'package:flutter/material.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Principal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(prefs.nombre),
          Divider(),
           Text(prefs.email),
          Divider(),
          RaisedButton(
              onPressed: () {
               prefs.token = '';
      prefs.email = '';
      prefs.nombre = '';
      Navigator.pushReplacementNamed(context, LoginPage.routeName);

              },
              child: Text("Marcar"),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }


}