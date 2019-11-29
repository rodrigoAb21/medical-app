import 'package:flutter/material.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';

class ListaMedicosPage extends StatefulWidget {
  static final String routeName = 'lista_medicos';

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Lista de Medicos')],
        ),
      ),
    );
  }
}
