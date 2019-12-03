import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/home_medico.dart';
import 'package:flutter_app_2/pages/home_usuario.dart';
import 'package:flutter_app_2/pages/register_medico.dart';
import 'package:flutter_app_2/pages/register_usuario.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';
  final BaseAuth auth = new Auth();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          _showForm(),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          showLogo(),
          showEmailInput(),
          showPasswordInput(),
          showPrimaryButton(),
          showSecondaryButton(),
          showThirdButton(),
        ],
      ),
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Email',
              hintText: 'Email',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          onChanged: (valor) {
            setState(() {
              _email = valor;
            });
          }),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Password',
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          onChanged: (valor) {
            setState(() {
              _password = valor;
            });
          }),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text('Registro de usuario',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          _registrarUsuario();
        });
  }

  Widget showThirdButton() {
    return new FlatButton(
        child: new Text('Registro de medico',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          _registrarMedico();
        });
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 20.0),
        child: SizedBox(
          height: 60.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            color: Colors.blue,
            child: new Text('Iniciar Sesion',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _verificar();
            },
          ),
        ));
  }

  _registrarUsuario() {
    Navigator.pushNamed(context, RegisterUsuarioPage.routeName);
  }

  _registrarMedico() {
    Navigator.pushNamed(context, RegisterMedicoPage.routeName);
  }

  _verificar() {
    if (_email != '' && _password != '') {
      _login();
    } else {
      Fluttertoast.showToast(msg: "Rellene todos los campos");
    }
  }

  _login() async {
    this.setState(() {
      isLoading = true;
      _email = _email.trim();
      _password = _password.trim();
    });

    String userId = '';
    try {
      userId = await widget.auth.signIn(_email, _password);
      print('Signed in: $userId');
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: "Verifique Email y password");
    }
    if (userId != '') {
      final prefs = new PreferenciasUsuario();
      prefs.id = userId;

      final String tipo = await Firestore.instance
          .collection('usuarios')
          .document(userId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['tipo'];
      });
      
      prefs.tipo = tipo;

      if (tipo != null) {
        this.setState(() {
        isLoading = false;
      });
        if (tipo == 'Usuario') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeUsuarioPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          await Firestore.instance.collection('usuarios').document(userId).updateData({'online': true});
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeMedicoPage()),
            (Route<dynamic> route) => false,
          );
        }
      }
    }
    this.setState(() {
      isLoading = false;
    });
  }
}
