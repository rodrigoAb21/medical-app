import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_2/models/resultado.dart';
import 'package:flutter_app_2/models/solicitud_diagnostico.dart';
import 'package:flutter_app_2/models/solicitud_parse.dart';
import 'package:flutter_app_2/utils/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Chatbot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatbotState();
  }
}

class _ChatbotState extends State<Chatbot> {
  /* ******************  VARIABLES ************************** */

  // 0 -> saludar; 1 -> Riesgos; 2 -> sintomas; 3 -> Single; 4 -> Resultado;
  int pagina = 0;
  String sintomas;
  SolicitudDiagnostico solicitudDiagnostico;
  String pregunta = '';
  int contador = 0;
  List<Resultado> resultados;
  double prob = 0.0;
  bool isLoading = false;
  final prefs = new PreferenciasUsuario();

  String questionId = '';
  int _questionChoice = 0; //0 = Si; 1 = No ; 2 = I dont know
  bool shouldStop = false;

  int _sobrepeso = 0; //0 = Si; 1 = No ; 2 = I dont know
  int _hypertension = 0; //0 = Si; 1 = No ; 2 = I dont know
  int _colesterol = 0; //0 = Si; 1 = No ; 2 = I dont know
  int _cigarrillos = 0; //0 = Si; 1 = No ; 2 = I dont know

  /* ******************  MANEJADORES RADIOBUTTONS ************************** */

  void _manejadorSingle(int value) {
    setState(() {
      _questionChoice = value;
    });
  }

  void _manejadorSobrepeso(int value) {
    setState(() {
      _sobrepeso = value;
    });
  }

  void _manejadorHypertension(int value) {
    setState(() {
      _hypertension = value;
    });
  }

  void _manejadorColesterol(int value) {
    setState(() {
      _colesterol = value;
    });
  }

  void _manejadorCigarrillo(int value) {
    setState(() {
      _cigarrillos = value;
    });
  }

  /* ******************  WIDGETS ************************** */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diagnostico Inteligente")),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              (pagina == 0)
                  ? _saludar()
                  : (pagina == 1)
                      ? _preguntarRiesgos()
                      : (pagina == 2)
                          ? _preguntarSintomas()
                          : (pagina == 3)
                              ? _mostrarSingle()
                              : _mostrarResultado(),
            ],
          ),
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
          )
        ],
      ),
    );
  }

  Widget _saludar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 180.0),
          Text(
            "Welcome to our smart diagnosis.",
            style: TextStyle(fontSize: 18.0),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 10.0),
              child: SizedBox(
                height: 65.0,
                width: 290.0,
                child: new RaisedButton(
                  elevation: 7.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.blue,
                  child: new Text('Start',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      pagina = 1;
                    });
                    inicializar();
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget _preguntarRiesgos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              child: Column(
                children: <Widget>[
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 7.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text: 'Am I overweight or obese?',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          RadioListTile(
                            title: Text('Yes'),
                            value: 0,
                            groupValue: _sobrepeso,
                            onChanged: _manejadorSobrepeso,
                          ),
                          RadioListTile(
                            title: Text('No'),
                            value: 1,
                            groupValue: _sobrepeso,
                            onChanged: _manejadorSobrepeso,
                          ),
                          RadioListTile(
                            title: Text('I dont know'),
                            value: 2,
                            groupValue: _sobrepeso,
                            onChanged: _manejadorSobrepeso,
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )),
                  SizedBox(height: 2.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 7.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Am i a smoker?',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile(
                          title: Text('Yes'),
                          groupValue: _cigarrillos,
                          value: 0,
                          onChanged: _manejadorCigarrillo,
                        ),
                        RadioListTile(
                          title: Text('No'),
                          groupValue: _cigarrillos,
                          value: 1,
                          onChanged: _manejadorCigarrillo,
                        ),
                        RadioListTile(
                          title: Text('I dont know'),
                          groupValue: _cigarrillos,
                          value: 2,
                          onChanged: _manejadorCigarrillo,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 7.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Do I have high cholesterol?',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile(
                          title: Text('Yes'),
                          groupValue: _colesterol,
                          value: 0,
                          onChanged: _manejadorColesterol,
                        ),
                        RadioListTile(
                          title: Text('No'),
                          groupValue: _colesterol,
                          value: 1,
                          onChanged: _manejadorColesterol,
                        ),
                        RadioListTile(
                          title: Text('I dont know'),
                          groupValue: _colesterol,
                          value: 2,
                          onChanged: _manejadorColesterol,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 7.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'I have hypertension?',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile(
                          title: Text('Yes'),
                          groupValue: _hypertension,
                          value: 0,
                          onChanged: _manejadorHypertension,
                        ),
                        RadioListTile(
                          title: Text('No'),
                          groupValue: _hypertension,
                          value: 1,
                          onChanged: _manejadorHypertension,
                        ),
                        RadioListTile(
                          title: Text('I dont know'),
                          groupValue: _hypertension,
                          value: 2,
                          onChanged: _manejadorHypertension,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: SizedBox(
                height: 60.0,
                width: 290.0,
                child: new RaisedButton(
                  elevation: 7.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.blue,
                  child: new Text('Next',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    agregarRiesgos();
                    setState(() {
                      pagina = 2;
                    });
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget _preguntarSintomas() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 180.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Please enter your symptoms.',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
            child: new TextFormField(
                maxLines: null,
                autofocus: false,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Symptoms',
                    hintText: 'Symptoms'),
                onChanged: (valor) {
                  setState(() {
                    sintomas = valor;
                  });
                }),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 10.0),
              child: SizedBox(
                height: 60.0,
                width: 290.0,
                child: new RaisedButton(
                  elevation: 7.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.blue,
                  child: new Text('Next',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () async {
                    await enviarSintomas();
                    setState(() {
                      pagina = 3;
                    });
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget _mostrarSingle() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 110.0),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 7.0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '$pregunta',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        RadioListTile(
                          title: Text('Yes'),
                          groupValue: _questionChoice,
                          value: 0,
                          onChanged: _manejadorSingle,
                        ),
                        RadioListTile(
                          title: Text('No'),
                          groupValue: _questionChoice,
                          value: 1,
                          onChanged: _manejadorSingle,
                        ),
                        RadioListTile(
                          title: Text('I dont know'),
                          groupValue: _questionChoice,
                          value: 2,
                          onChanged: _manejadorSingle,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: SizedBox(
                height: 60.0,
                width: 290.0,
                child: new RaisedButton(
                  elevation: 7.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.blue,
                  child: new Text('Next',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    if (contador >= 15 || shouldStop || prob > 0.8) {
                      enviarSolicitudDiagnostico();
                      setState(() {
                        pagina = 4;
                        contador = -1;
                        pregunta = '';
                        _questionChoice = 0;
                        prob = 0.0;
                      });
                    } else {
                      enviarSolicitudDiagnostico();
                    }
                    setState(() {
                      contador++;
                    });
                  },
                ),
              ))
        ],
      ),
    ));
  }

  Widget _mostrarResultado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 100.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Resultados del diagnostico',
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 40.0),
          _mostrarListaResultado(),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 10.0),
              child: SizedBox(
                height: 60.0,
                width: 290.0,
                child: new RaisedButton(
                  elevation: 7.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.blue,
                  child: new Text('Finish',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      pagina = 0;
                    });
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget _mostrarListaResultado() {
    List<Widget> lista = new List<Widget>();
    for (var item in resultados) {
      double p = item.probabilidad * 100;
      lista.add(Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  '${item.nombre}',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text('${p.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 17.0),
                    textAlign: TextAlign.center),
                onTap: () {},
              ),
            ],
          ),
        ),
      )));
    }
    return Column(children: lista);
  }

  /* *******************************FUNCIONES VARIAS*****************************   */

  // INICIALIZANDO SOLICITUD PRINCIPAL
  inicializar() {
    solicitudDiagnostico = new SolicitudDiagnostico();

    solicitudDiagnostico.age = prefs.edad != 0 ? prefs.edad : 25;
    solicitudDiagnostico.sex = prefs.sexo != '' ? prefs.sexo : 'male';

    solicitudDiagnostico.extras = new Extras(true);

    // SINTOMAS
    List evidencias = new List<Evidence>();
    solicitudDiagnostico.evidence = evidencias;
  }

  // AGREGANDO LOS RIESGOS A LA SOLICITUD PRINCIPAL
  agregarRiesgos() {
    // Sobrepeso
    solicitudDiagnostico.evidence.add(new Evidence(
        'p_7',
        _sobrepeso == 0 ? 'present' : _sobrepeso == 1 ? 'absent' : 'unknown',
        true));
    solicitudDiagnostico.evidence.add(new Evidence(
        'p_28',
        _cigarrillos == 0
            ? 'present'
            : _cigarrillos == 1 ? 'absent' : 'unknown',
        true));
    solicitudDiagnostico.evidence.add(new Evidence(
        'p_10',
        _colesterol == 0 ? 'present' : _colesterol == 1 ? 'absent' : 'unknown',
        true));
    solicitudDiagnostico.evidence.add(new Evidence(
        'p_9',
        _hypertension == 0
            ? 'present'
            : _hypertension == 1 ? 'absent' : 'unknown',
        true));

    setState(() {
      _sobrepeso = 0;
      _hypertension = 0;
      _colesterol = 0;
      _cigarrillos = 0;
    });
  }

  // ENVIAR SINTOMAS AL PARSE
  enviarSintomas() async {
    setState(() {
      isLoading = true;
    });
    SolicitudParse solicitudParse = new SolicitudParse();
    solicitudParse.text = sintomas;

    try {
      final resp = await http.post('https://api.infermedica.com/v2/parse',
          body: jsonEncode(solicitudParse),
          headers: {
            "App_Id": "91ae0b88",
            "App-Key": "87e3dda092ef23acbe72493530bd2b0f",
            "Content-Type": "application/json"
          }).catchError((onError) {
        print(onError);
      });
      if (resp.statusCode == 200) {
        var decodedResp = convert.jsonDecode(resp.body);

        List<dynamic> l =
            convert.jsonDecode(convert.jsonEncode(decodedResp['mentions']));
        l.forEach((item) => (solicitudDiagnostico.evidence
            .add(new Evidence(item['id'], 'present', true))));

        await enviarSolicitudDiagnostico();
      }
    } catch (e) {
      print(e);
    }
  }

  // ENVIAR DATOS AL DIAGNOSTICO
  enviarSolicitudDiagnostico() async {
    setState(() {
      isLoading = true;
    });
    if (pagina == 3) {
      // SI SIGO EN LA MISMA PAGINA AGREGAR RESPUESTA ANTERIOR
      solicitudDiagnostico.evidence.add(new Evidence(
          questionId,
          _questionChoice == 0
              ? 'present'
              : _questionChoice == 1 ? 'absent' : 'unknown',
          false));
    }

    // ENVIAMOS LA SOLICITUD AL DIAGNOSIS
    try {
      final resp = await http.post('https://api.infermedica.com/v2/diagnosis',
          body: jsonEncode(solicitudDiagnostico),
          headers: {
            "App_Id": "91ae0b88",
            "App-Key": "87e3dda092ef23acbe72493530bd2b0f",
            "Content-Type": "application/json"
          }).catchError((onError) {
        print(onError);
      });

      // SI ESTA OK, CAPTURAR LA PREGUNTA Y EL ID DEL SINTOMA
      if (resp.statusCode == 200) {
        // BODY
        var decodedResp = convert.jsonDecode(resp.body);

        // BODY.QUESTION
        var respQuestion =
            convert.jsonDecode(convert.jsonEncode(decodedResp['question']));

        // BODY.QUESTION.ITEMS
        List<dynamic> l =
            convert.jsonDecode(convert.jsonEncode(respQuestion['items']));

        //print("ID_SINTOMA_PREGUNTA" + l.first['id']);

        setState(() {
          shouldStop = decodedResp['should_stop'];
          pregunta = respQuestion['text'];
          questionId = l.first['id'];
          _questionChoice = 0;
        });
        guardarResultados(jsonEncode(decodedResp['conditions']));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  guardarResultados(String conditions) {
    resultados = new List<Resultado>();
    try {
      List<dynamic> lista = jsonDecode(conditions);
      if (lista.length > 0) {
        setState(() {
          prob = lista[0]['probability'];
        });
      }
      for (var i = 0; i < lista.length; i++) {
        resultados.add(
            new Resultado(lista[i]['common_name'], lista[i]['probability']));
        if (i == 2) {
          break;
        }
      }
    } catch (e) {
      print(e);
    }
    print('Probabilidad: $prob');
  }
}
