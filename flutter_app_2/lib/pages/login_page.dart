import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/home_page.dart';
import 'package:flutter_app_2/pages/register_page.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';

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
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Email',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
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
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onChanged: (valor) {
            setState(() {
              _password = valor;
            });
          }),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text('Create an account',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          _registrar();
        });
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _enviar();
            },
          ),
        ));
  }

  _registrar() {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  _enviar() async {
    this.setState(() {
      isLoading = true;
    });

    String userId = '';
    try {
      userId = await widget.auth.signIn(_email, _password);
      print('Signed in: $userId');
    } catch (e) {
      print('Error: $e');
    }
    if (userId != '') {
      final prefs = new PreferenciasUsuario();
      prefs.uid = userId;
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
