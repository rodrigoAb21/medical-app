class SolicitudDiagnostico {
  String sex;
  int age;
  Extras extras;
  List<Evidence> evidence;

  SolicitudDiagnostico();

  Map<String, dynamic> toJson() =>
    {
      'sex': sex,
      'age' : age,
      'extras': extras,
      'evidence': evidence
    };
}

class Evidence {
  String id;
  String choiceId;
  bool initial;

  Evidence(this.id, this.choiceId, this.initial);

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'choice_id' : choiceId,
      'initial': initial
    };
}

class Extras {
  bool disableGroups;

  Extras(this.disableGroups);

  Map<String, dynamic> toJson() =>
    {
      'disable_groups': disableGroups
    };
}
