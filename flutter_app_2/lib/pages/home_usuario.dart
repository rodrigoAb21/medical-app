import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


 @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance.collection('usuarios').document(prefs.id).updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

    void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'sw.uagrm.flutter_app_2': 'sw.uagrm.flutter_app_2',
      'Medical App',
      '--',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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
    _handleURLButtonPress(context);
  }

  void _handleURLButtonPress(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chatbot()));
  }
}
