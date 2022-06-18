import 'contestant.dart';

class Game {

  int? _id;
  int?  _player1;
  int? _player2;
  int? _goals1;
  int? _goals2;
  int? _tournamentId;

  Game(id, player1,player2,goals1,goals2, tournamentId){
    this._id=id;
    this._player1 = player1;
    this._player2 = player2;
    this._goals1 = goals1;
    this._goals2 = goals2;
    this._tournamentId = tournamentId;

  }

  Game.fromDb(Map<String,dynamic> parsedJson)
      : _player1= parsedJson['idUcesnika1'],
        _player2 = parsedJson['idUcesnika2'],
        _goals1 = parsedJson['golovi1'],
        _goals2 = parsedJson['golovi2'],
        _id = parsedJson['id'],
        _tournamentId = parsedJson['idTurnira'];

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "idUcesnika1" : _player1,
      "idUcesnika2" : _player2,
      "golovi1" : _goals1,
      "golovi2" : _goals2,
      "id" : _id,
      "idTurnira" : _tournamentId
    };
  }

  int? get id=> _id;

  int? get player1 => _player1;
  int? get player2 => _player2;

  int? get goals1=>_goals1;
  int? get goals2=>_goals2;

  int? get tournamentId => _tournamentId;

  void setGoals1(int goals){
    _goals1 = goals;
  }

  void setGoals2(int goals){
    _goals2 = goals;
  }


}