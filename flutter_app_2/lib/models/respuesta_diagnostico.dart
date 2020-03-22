class RespuestaDiagnostico {
  Question question;
  List<Condition> conditions;
  bool shouldStop;
}

class Question {
  String type;
  String text;
  List<Item> items;
}

class Condition {
  String id;
  String name;
  String commonName;
  double probability;
}

class Item {
  String id;
  String name;
  List<Choice> choices;
}

class Choice {
  String id;
  String label;
}
