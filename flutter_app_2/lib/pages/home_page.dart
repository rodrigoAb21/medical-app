import 'package:flutter/material.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  final BaseAuth auth = new Auth();

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
            Text(prefs.uid),
            Divider(),
            RaisedButton(
              onPressed: () {
                logout();
              },
              child: Text("Log Out"),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  logout() async {
    try {
      await widget.auth.signOut();
      prefs.uid = '';
      prefs.nombre = '';
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      print('Cerrando sesion');
    } catch (e) {
      print('error: $e');
    }
  }
}
