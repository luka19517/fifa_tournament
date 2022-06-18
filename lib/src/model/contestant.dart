class Contestant{

  int? _id;
  int? _playerId;
  int? _tournamentId;

  int? _goalsScored;
  int? _goalsAllowed;
  int? _points;

  int? _position;

  Contestant(int id,int playerId, int tournamentId, int goalsScored, int goalsAllowed, int points, int position ){
    this._id=id;
    this._playerId = playerId;
    this._tournamentId = tournamentId;
    this._goalsScored=goalsScored;
    this._goalsAllowed=goalsAllowed;
    this._points=points;
    this._position = position;
  }

  Contestant.fromDb(Map<String,dynamic> parsedJson)
    :   _id = parsedJson['id'],
        _playerId = parsedJson['idIgraca'],
        _tournamentId = parsedJson['idTurnira'],
        _goalsScored = parsedJson['brojDatihGolova'],
        _points = parsedJson['brojBodova'],
        _goalsAllowed = parsedJson['brojPrimljenihGolova'],
        _position = parsedJson['pozicija'];


  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id" : _id,
      "idIgraca" : _playerId,
      "idTurnira" : _tournamentId,
      "brojDatihGolova": _goalsScored,
      "brojPrimljenihGolova": _goalsAllowed,
      "brojBodova": _points,
      "pozicija": _position
    };
  }


  int? get goalsScored => _goalsScored;

  int? get goalsAllowed => _goalsAllowed;

  int? get points => _points;

  int? get id => _id;

  int? get playerId => _playerId;

  int? get tournamentId => _tournamentId;

  int? get position => _position;

  void setGoalsScored(int goalsScored){
    this._goalsScored = goalsScored;
  }

  void setGoalsAllowed(int goalsAllowed){
    this._goalsAllowed = goalsAllowed;
  }

  void setPoints(int points){
    this._points = points;
  }

  void setId(int id){
    this._id = id;
  }

  void setPlayerId(int id){
    this._playerId = id;
  }
  void setTournamentId(int id){
    this._tournamentId = id;
  }

  void setPosition(int position){
    this._position = position;
  }

}