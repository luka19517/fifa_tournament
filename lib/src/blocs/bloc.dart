import 'dart:async';


import 'package:fifa_tournament/src/model/player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import './validators/name_validator.dart';
import '../model/game.dart';
import '../model/contestant.dart';
import '../resources/db_provider.dart';
import 'dart:convert';

class Bloc with NameValidators {
  final _player1Name = BehaviorSubject<String>();
  final _player2Name = BehaviorSubject<String>();
  final _player3Name = BehaviorSubject<String>();

  final _newPlayerName = BehaviorSubject<String>();

  final _homePlayers = [BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>()];

  final _guestPlayers = [BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>(),BehaviorSubject<String>()];

  Stream<String> get player1Name => _player1Name.stream.transform(validatePlayer1);
  Stream<String> get player2Name => _player2Name.stream.transform(validatePlayer2);
  Stream<String> get player3Name => _player3Name.stream.transform(validatePlayer3);
  Stream<String> get newPlayerName => _newPlayerName.stream.transform(validatePlayer3);

  Stream<String> homePlayer(int gameIndex){
    return _homePlayers[gameIndex].stream;
  }

  Stream<String> guestPlayer(int gameIndex){
    return _guestPlayers[gameIndex].stream;
  }

  List<Contestant>? _currentContestants;

  List<Contestant>? get currentContestants => _currentContestants;

  Stream<bool> get submitValid => Observable.combineLatest3(player1Name, player2Name, player3Name, (p1,p2,p3)=> true);

  submitContestants(context,tournamentId) async{


    //TODO Ovo je mesto gde se desavaju sledece akcije:
    // U tabelu ucesnici dodaju se slogovi sa automatski izgenerisanim idjem, id igraca ce biti postojeci ako se ime poklapa u suportnom
    // u tabeli Igraci se pravi novi slog sa datim imenom, novim idjem , ostalo null, a taj id se daje kao id igraca u tabeli ucesnik
    // broj bodova 0, broj datih golova 0
    // broj primljenih golova nula
    // pozicija 1
    // turnir id je ovaj koji je napravljen

    Player player1 = await dbProvider.fetchPlayerByName(_player1Name.value);
    Player player2 = await dbProvider.fetchPlayerByName(_player2Name.value);
    Player player3 = await dbProvider.fetchPlayerByName(_player3Name.value);

    int nextContestantId = await dbProvider.nextContestantId();

    dbProvider.addContestant(Contestant(nextContestantId+1, player1.id as int, tournamentId, 0, 0, 0,1));
    dbProvider.addContestant(Contestant(nextContestantId+2, player2.id as int, tournamentId, 0, 0, 0,1));
    dbProvider.addContestant(Contestant(nextContestantId+3, player3.id as int, tournamentId, 0, 0, 0,1));


    Navigator.pushNamed(context, '/fixtures');
  }

  submitNewPlayer(context, int id){
    //TODO u bazu dodati igraca sa izracunatim idjem , i imenom
    String nameToInsert = _newPlayerName.value;

    print(id);
    dbProvider.addPlayer(Player(id, nameToInsert));
    Navigator.pop(context);


  }

  submitResults(context,List<Contestant> contestants,List<Game> games){

    calculatePlayer1Stats(contestants,games);
    calculatePlayer2Stats(contestants, games);
    calculatePlayer3Stats(contestants,games);

    for(var i=0 ; i< games.length;i++){
      games[i].setGoals1(int.parse(_homePlayers[i].value));
      games[i].setGoals2(int.parse(_guestPlayers[i].value));
    }

    int position1 = 1;
    int position2 = 1;
    int position3 = 1;
    if(compare(contestants[0],contestants[1])>=0)
      position2++;
    else
      position1++;
    if(compare(contestants[0],contestants[2])>=0)
      position3++;
    else
      position1++;
    if(compare(contestants[1],contestants[2])>=0)
      position3++;
    else
      position2++;


    contestants[0].setPosition(position1);
    contestants[1].setPosition(position2);
    contestants[2].setPosition(position3);

    dbProvider.deleteContestant(contestants[0].id as int);
    dbProvider.deleteContestant(contestants[1].id as int);
    dbProvider.deleteContestant(contestants[2].id as int);

    dbProvider.addContestant(contestants[0]);
    dbProvider.addContestant(contestants[1]);
    dbProvider.addContestant(contestants[2]);


    //TODO rad sa bazom : u tabelu Rezultat se dodaju novi slogovi  i navigacija na stranicu

    print('Golova u prvoj tekmi: ${games[0].goals1}');
    for(Game game in games){
      dbProvider.addGame(game);
    }

    Navigator.pushNamed(context, '/rankings');


  }

  int compare(Contestant p1, Contestant p2){
    if((p1.points as int) > (p2.points as int))
      return 1;
    if((p1.points as int) < (p2.points as int))
      return -1;
    if(((p1.goalsScored as int)-(p1.goalsAllowed as int)) > ((p2.goalsScored as int)-(p2.goalsAllowed as int)))
      return 1;
    if(((p1.goalsScored as int)-(p1.goalsAllowed as int)) < ((p2.goalsScored as int)-(p2.goalsAllowed as int)))
      return -1;
    if((p1.goalsScored as int) > (p2.goalsAllowed as int))
      return 1;
    if((p1.goalsScored as int) < (p2.goalsAllowed as int))
      return -1;
    return 0;
  }

  calculatePlayer1Stats(List<Contestant> contestants, List<Game> games){
    int points  = 0;
    int goalsScored = 0;
    int goalsAllowed = 0;
    for(int i = 0;i<9;i++){
      if(i%3!=2){
        goalsScored+=int.parse(_homePlayers[i].value);
        goalsAllowed+=int.parse(_guestPlayers[i].value);
        if(int.parse(_homePlayers[i].value)>int.parse(_guestPlayers[i].value))
          points+=3;
      }
    }

    contestants[0].setPoints(points);
    contestants[0].setGoalsScored(goalsScored);
    contestants[0].setGoalsAllowed(goalsAllowed);
  }

  calculatePlayer2Stats(List<Contestant> players, List<Game> games){
    int points  = 0;
    int goalsScored = 0;
    int goalsAllowed = 0;
    for(int i = 0;i<9;i++){
      if(i%3==0){
        goalsScored+=int.parse(_guestPlayers[i].value);
        goalsAllowed+=int.parse(_homePlayers[i].value);
        if(int.parse(_homePlayers[i].value)<int.parse(_guestPlayers[i].value))
          points+=3;
      }

      if(i%3==2){
        goalsAllowed+=int.parse(_guestPlayers[i].value);
        goalsScored+=int.parse(_homePlayers[i].value);
        if(int.parse(_homePlayers[i].value)>int.parse(_guestPlayers[i].value))
          points+=3;
      }


    }

    players[1].setPoints(points);
    players[1].setGoalsScored(goalsScored);
    players[1].setGoalsAllowed(goalsAllowed);
  }

  calculatePlayer3Stats(List<Contestant> players, List<Game> games){
    int points  = 0;
    int goalsScored = 0;
    int goalsAllowed = 0;
    for(int i = 0;i<9;i++){
      if(i%3!=0){
        goalsScored+=int.parse(_guestPlayers[i].value);
        goalsAllowed+=int.parse(_homePlayers[i].value);
        if(int.parse(_homePlayers[i].value)<int.parse(_guestPlayers[i].value))
          points+=3;
      }
    }
    players[2].setPoints(points);
    players[2].setGoalsScored(goalsScored);
    players[2].setGoalsAllowed(goalsAllowed);

  }



  String get currentPlayer1Name => _player1Name.value;
  String get currentPlayer2Name => _player2Name.value;
  String get currentPlayer3Name => _player3Name.value;



  Function(String) get changePlayer1 => _player1Name.sink.add;
  Function(String) get changePlayer2 => _player2Name.sink.add;
  Function(String) get changePlayer3 => _player3Name.sink.add;

  Function(String) get changeNewPlayerName => _newPlayerName.sink.add;

  Function(String) changeHomePlayer(int gameIndex){
    return _homePlayers[gameIndex].sink.add;
  }

  Function(String) changeGuestPlayer(int gameIndex){
    return _guestPlayers[gameIndex].sink.add;
  }

  int? _currentTournamentId;

  int? get currentTournamentId => _currentTournamentId;

  void setCurrentTournamentId(int id){
    _currentTournamentId = id;
  }

  int? _currentTournamentIdToSeeDetails;
  int? get currentTournamentIdToSeeDetails => _currentTournamentIdToSeeDetails;
  void setCurrentTournamentIdToSeeDetails(int id){
    _currentTournamentIdToSeeDetails = id;
  }

  int? _currentPlayerIdToSeeDetails;
  int? get currentPlayerIdToSeeDetails => _currentPlayerIdToSeeDetails;
  void setCurrentPlayerIdToSeeDetails(int id){
    _currentPlayerIdToSeeDetails = id;
  }





}

final bloc = Bloc();