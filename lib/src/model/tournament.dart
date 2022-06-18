class Tournament{
  int? _id;
  String? _date;

  Tournament(int id, String date){
    _id = id;
    _date = date;
  }

  int? get id => _id;

  String? get date => _date;

  void setId(int id){
    _id = id;
  }

  void setDate(String date){
    _date = date;
  }

  Tournament.fromDb(Map<String,dynamic> parsedJson)
      : _id = parsedJson['id'],
        _date = parsedJson['datum'];

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id" : _id,
      "datum" : _date
    };
  }


}