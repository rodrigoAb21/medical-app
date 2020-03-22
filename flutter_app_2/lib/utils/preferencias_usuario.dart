import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String getPagina() {
    if (this.id != null && this.id != '' && this.tipo != '') {
      if (this.tipo == 'Medico') {
        return 'lista_pacientes';
      } else {
        if (this.pago) {
          if (this.peerId != '') {
            return 'chat_usuario';
          } else {
            return 'lista_medicos';
          }
        } else {
          return 'home_usuario';
        }
      }
    }
    return 'login';
  }

  get id {
    return _prefs.getString('id') ?? '';
  }

  set id(String value) {
    _prefs.setString('id', value);
  }

  get nombre {
    return _prefs.getString('nombre') ?? '';
  }

  set nombre(String value) {
    _prefs.setString('nombre', value);
  }

   get edad {
    return _prefs.getInt('edad') ?? 0;
  }

  set edad(int value) {
    _prefs.setInt('edad', value);
  }


  get sexo {
    return _prefs.getString('sexo') ?? '';
  }

  set sexo(String value) {
    _prefs.setString('sexo', value);
  }


  get pago {
    return _prefs.getBool('pago') ?? false;
  }

  set pago(bool value) {
    _prefs.setBool('pago', value);
  }

  get tipo {
    return _prefs.getString('tipo') ?? '';
  }

  set tipo(String value) {
    _prefs.setString('tipo', value);
  }

 get peerId {
    return _prefs.getString('peerId') ?? '';
  }

  set peerId(String value) {
    _prefs.setString('peerId', value);
  }

  get peerAvatar {
    return _prefs.getString('peerAvatar') ?? '';
  }

  set peerAvatar(String value) {
    _prefs.setString('peerAvatar', value);
  }


}
