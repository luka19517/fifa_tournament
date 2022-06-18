class Player {
  int? _id;
  String? _ime;
  //TODO datum rodjenja , slika, statistika id

  Player(int id , String ime){
    this._id = id;
    this._ime = ime;
  }

  String? get ime => _ime;
  int? get id => _id;

  Player.fromDb(Map<String,dynamic> parsedJson)
    : _id = parsedJson['id'],
      _ime = parsedJson['ime'];

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id" : _id,
      "ime" : _ime
    };
  }
}