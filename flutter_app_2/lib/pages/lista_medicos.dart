import 'package:flutter/material.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';

class ListaMedicosPage extends StatefulWidget {
  static final String routeName = 'lista_medicos';
  final BaseAuth auth = new Auth();

  @override
  _ListaMedicosPageState createState() => _ListaMedicosPageState();
}

class _ListaMedicosPageState extends State<ListaMedicosPage> {
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicos disponibles'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _terminarConsulta();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("data")
          ],
        ),
      ),
    );
  }

  _terminarConsulta() async {
    try {
      prefs.pago = false;
      Fluttertoast.showToast(msg: "Consulta finalizada.");
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } catch (e) {
      print('error: $e');
    }
  }
}
