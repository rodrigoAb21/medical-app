import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/pages/home_usuario.dart';
import 'package:flutter_app_2/services/authentication.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUsuarioPage extends StatefulWidget {
  static final String routeName = 'registrar_usuario';
  final BaseAuth auth = new Auth();

  @override
  _RegisterUsuarioPageState createState() => _RegisterUsuarioPageState();
}

class _RegisterUsuarioPageState extends State<RegisterUsuarioPage> {
  String _email = '';
  String _password = '';
  String _nombre = '';
  String _edad = '';
  String _telefono = '';
  bool isLoading = false;

  int _sexo = 0; //0 = Masculino; 1 = Femenino

  void _handleRadioValueChange1(int value) {
    setState(() {
      _sexo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
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
          showNombreInput(),
          showEdadInput(),
          showSexo(),
          showTelefonoInput(),
          showEmailInput(),
          showPasswordInput(),
          showPrimaryButton(),
        ],
      ),
    );
  }

  Widget showNombreInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          autofocus: false,
          decoration: new InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Nombre',
              hintText: 'Nombre',
              icon: new Icon(
                Icons.account_circle,
                color: Colors.grey,
              )),
          onChanged: (valor) {
            setState(() {
              _nombre = valor;
            });
          }),
    );
  }

  Widget showEdadInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: new InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Edad',
              hintText: 'Edad',
              icon: new Icon(
                Icons.cake,
                color: Colors.grey,
              )),
          onChanged: (valor) {
            setState(() {
              _edad = valor;
            });
          }),
    );
  }


  Widget showTelefonoInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: new InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Telefono',
              hintText: 'Telefono',
              icon: new Icon(
                Icons.phone,
                color: Colors.grey,
              )),
          onChanged: (valor) {
            setState(() {
              _telefono = valor;
            });
          }),
    );
  }

  Widget showSexo() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.accessibility,
              color: Colors.grey,
            ),
            new Radio(
              value: 0,
              groupValue: _sexo,
              onChanged: _handleRadioValueChange1,
            ),
            new Text(
              'Masculino',
              style: new TextStyle(fontSize: 17.0),
            ),
            new Radio(
              value: 1,
              groupValue: _sexo,
              onChanged: _handleRadioValueChange1,
            ),
            new Text(
              'Femenino',
              style: new TextStyle(
                fontSize: 17.0,
              ),
            ),
          ],
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: SizedBox(
          height: 60.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            color: Colors.blue,
            child: new Text('Guardar',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _verificar();
            },
          ),
        ));
  }

  _verificar() {
    this.setState(() {
      _nombre = _nombre.trim();
      _email = _email.trim();
      _password = _password.trim();
      _edad = _edad.trim();
      _telefono = _telefono.trim();
    });
    if (_nombre != '' && _email != '' && _telefono != '' && _password != '' && _edad != '' && _password.length >= 6) {
      _registrar();
    } else {
      Fluttertoast.showToast(msg: "Rellene todos los campos");
    }
  }

  _registrar() async {
    this.setState(() {
      isLoading = true;
    });

    String userId = '';

    try {
      userId = await widget.auth.signUp(_email, _password);
      print('Signed in: $userId');
    } catch (e) {
      print('Error: $e');
    }
    if (userId != '') {
      final usuario = {
        'id': userId,
        'nombre': _nombre,
        'email': _email,
        'password': _password,
        'edad': _edad,
        'telefono': _telefono,
        'chattingWith' : null,
        'doctor': null,
        'photoUrl' : 'https://agendavirtual.vpsnotas.com/Content/Images/default-user.png',
        'tipo': 'Usuario',
        'sexo': _sexo == 0 ? 'Masculino' : 'Femenino',
      };
      await Firestore.instance
          .collection('usuarios')
          .document(userId)
          .setData(usuario)
          .then((valor) {
        Fluttertoast.showToast(msg: "Registro exitoso");
      }).catchError((e) {
        Fluttertoast.showToast(msg: "No se pudieron guardar todos sus datos.");
        print(e);
      });

      final prefs = new PreferenciasUsuario();
      prefs.id = userId;
      prefs.tipo = 'Usuario';
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeUsuarioPage()),
        (Route<dynamic> route) => false,
      );
    }
    this.setState(() {
      isLoading = false;
    });
  }
}
