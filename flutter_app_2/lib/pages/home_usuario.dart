import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/chatbot.dart';
import 'package:flutter_app_2/pages/lista_medicos.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

import 'login_page.dart';

class HomeUsuarioPage extends StatefulWidget {
  static final String routeName = 'home_usuario';
  final BaseAuth auth = new Auth();

  @override
  _HomeUsuarioPageState createState() => _HomeUsuarioPageState();
}

class _HomeUsuarioPageState extends State<HomeUsuarioPage> {
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
              showAlertDialog();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showIAButton(),
            showConsultaButton(),
          ],
        ),
      ),
    );
  }

  showAlertDialog() {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("SI"),
      onPressed: () {
        Navigator.of(context).pop();
        _cerrarSesion();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cerrar Sesion"),
      content: Text("Esta seguro de finalizar la sesion?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget showIAButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: SizedBox(
          height: 90.0,
          width: 290.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            color: Colors.blue,
            child: new Text('Diagnostico Inteligente',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _irDiagnosticoInteligente();
            },
          ),
        ));
  }

  Widget showConsultaButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
        child: SizedBox(
          height: 90.0,
          width: 290.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            color: Colors.blue,
            child: new Text('Consulta Medica',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _irConsultaMedica();
            },
          ),
        ));
  }

  void _pay() {
    InAppPayments.setSquareApplicationId('sq0idp-H-_InHJW3LzZyJ69cfngdw');
    InAppPayments.startCardEntryFlow(
      onCardEntryCancel: _cardEntryCancel,
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    );
  }

  void _cardEntryCancel() {}

  void _cardNonceRequestSuccess(CardDetails result) {
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() {
    prefs.pago = true;
    Navigator.pushReplacementNamed(context, ListaMedicosPage.routeName);
  }

  _cerrarSesion() async {
    try {
      await widget.auth.signOut();
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

  _irConsultaMedica() {
    _pay();
  }

  _irDiagnosticoInteligente() {
    _handleURLButtonPress(context, 'https://symptomate.com/chatbot/');
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
