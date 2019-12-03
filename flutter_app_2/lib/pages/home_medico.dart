import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';

class HomeMedicoPage extends StatefulWidget {
  static final String routeName = 'home_medico';
  final BaseAuth auth = new Auth();

  @override
  _HomeMedicoPageState createState() => _HomeMedicoPageState();
}

class _HomeMedicoPageState extends State<HomeMedicoPage> {
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Principal"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _cerrarSesion();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('HOME MEDICO')
          ],
        ),
      ),
    );
  }

  
  _cerrarSesion() async {
    try {
      await widget.auth.signOut();
      await Firestore.instance.collection('usuarios').document(prefs.id).updateData({'online': false});
      prefs.id = '';
      prefs.nombre = '';
      prefs.pago = false;
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      Fluttertoast.showToast(msg: "Sesion terminada.");
      print('Cerrando sesion');
    } catch (e) {
      print('error: $e');
    }
  }
}
