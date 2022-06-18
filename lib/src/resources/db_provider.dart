import 'package:fifa_tournament/src/model/contestant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../model/player.dart';
import '../model/tournament.dart';
import '../model/game.dart';

class DbProvider {
  Database? db;

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    WidgetsFlutterBinding.ensureInitialized();
    final path = join(documentsDirectory.path, 'items.db');
    print(path);
    db = await openDatabase(path, version: 2,
        onCreate: (Database myDb, int version) {
      createPlayerTable(myDb);
      createContestantTable(myDb);
      createTournamentTable(myDb);
      createResultTable(myDb);
    });
  }

  createPlayerTable(myDb) async {
    await myDb.execute("""
          CREATE TABLE Igrac
            (
              id INTEGER PRIMARY KEY,
              ime TEXT           
            )
        """);
  }

  createContestantTable(myDb) async {
    await myDb.execute("""
          CREATE TABLE Ucesnik
            (
              id INTEGER PRIMARY KEY,
              idIgraca INTEGER,
              idTurnira INTEGER,
              brojBodova INTEGER,
              brojDatihGolova INTEGER,
              brojPrimljenihGolova INTEGER,
              pozicija INTEGER
              
            )
        """);
  }

  createTournamentTable(myDb) async {
    await myDb.execute("""
          CREATE TABLE Turnir
            (
              id INTEGER PRIMARY KEY,
              datum TEXT
            )
        """);
  }

  createResultTable(myDb)async {
    await myDb.execute("""
          CREATE TABLE Rezultat
            (
              id INTEGER PRIMARY KEY,
              idUcesnika1 INTEGER,
              idUcesnika2 INTEGER,
              golovi1 INTEGER,
              golovi2 INTEGER,
              idTurnira INTEGER
            )
        """);
  }

  Future<int> fetchNumberOfTournamentsFromPlayer(int playerId) async{
    final maps = await db!.query(
      "Ucesnik",
      columns: null,
      where: 'idIgraca = ?',
      whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result++;

    print('$result');
    return result;
  }

  Future<int> fetchNumberOffFirstPositions(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ? and pozicija=1',
        whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result++;

    return result;
  }

  Future<int> fetchNumberOffSecondPositions(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ? and pozicija=2',
        whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result++;

    return result;
  }

  Future<int> fetchNumberOffThirdPositions(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ? and pozicija=3',
        whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result++;

    return result;
  }

  Future<int> fetchTotalGoalsScored(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ?',
        whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result+= (Contestant.fromDb(item).goalsScored as int);

    return result;
  }

  Future<int> fetchTotalGoalsAllowed(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ?',
        whereArgs: [playerId]
    );

    int result = 0;

    for(var item in maps)
      result+= (Contestant.fromDb(item).goalsAllowed as int);

    return result;
  }


  Future<double> playerWinningPercentage(int playerId) async{
    final maps = await db!.query(
        "Ucesnik",
        columns: null,
        where: 'idIgraca = ?',
        whereArgs: [playerId]
    );

    List<Contestant> contestants = [];
    double gamesWon = 0.0;
    double gamesPlayed = 0.0;

    for(var item in maps) {
      Contestant contestant = Contestant.fromDb(item);
      int contestantId = contestant.id as int;
      List<Game> games = await fetchGamesFromContestant(contestantId);

      for(Game game in games){
        gamesPlayed+=1.0;
        if(game.player1 == contestantId && (game.goals1 as int)>(game.goals2 as int))
          gamesWon+=1.0;
        if(game.player2== contestantId && (game.goals1 as int)<(game.goals2 as int))
          gamesWon+=1.0;
      }

    }
    return (gamesWon/gamesPlayed)*100;
  }

  Future<List<Player>> fetchAllPlayers() async {
    final maps = await db!.query(
      "Igrac",
      columns: null,
    );
    List<Player> result = [];

    for (var item in maps) {
      result.add(Player.fromDb(item));
    }
    print('UKUPAN BROJ IGRACA ${result.length}');
    return result;
  }

  Future<List<Tournament>> fetchAllTournaments() async {
    final maps = await db!.query(
      "Turnir",
      columns: null,
    );
    List<Tournament> result = [];
    for (var item in maps) {
      result.add(Tournament.fromDb(item));
    }

    return result;
  }

  Future<List<Contestant>> fetchAllContestants() async {
    final maps = await db!.query(
      "Ucesnik",
      columns: null,
    );
    List<Contestant> result = [];
    for (var item in maps) {
      result.add(Contestant.fromDb(item));
    }

    return result;
  }

  Future<List<Contestant>> fetchAllTournamentConestants(
      int tournamentId) async {

    final maps = await db!.query("Ucesnik",
        columns: null,
        where: "idTurnira= ?",
        whereArgs: [tournamentId],
        orderBy: 'pozicija ASC');
    List<Contestant> result = [];
    for (var item in maps) {
      result.add(Contestant.fromDb(item));
    }

    return result;
  }

  Future<List<Game>> fetchAllGames() async{
    final maps = await db!.query(
          "Rezultat",
          columns: null);

    List<Game> result = [];
    for (var item in maps) {
      result.add(Game.fromDb(item));
    }

    return result;
  }

  Future<List<Game>> fetchGamesFromTournament(int tournamentId) async{
    final maps = await db!.query(
          "Rezultat",
          columns:null,
          where: "idTurnira= ?",
          whereArgs: [tournamentId]
    );
    List<Game> result = [];
    for (var item in maps) {
      result.add(Game.fromDb(item));
    }

    return result;

  }

  Future<List<Game>> fetchGamesFromContestant(int contestantId) async{
    final maps = await db!.query(
        "Rezultat",
        columns:null,
        where: "idUcesnika1=? or idUcesnika2=?",
        whereArgs: [contestantId,contestantId]
    );
    List<Game> result = [];
    for (var item in maps) {
      result.add(Game.fromDb(item));
    }

    return result;

  }

  Future<Player> fetchPlayerById(int id) async {
    print('PREDAT id za uzimanje igraca za izvlacenje imena Igraca $id');
    final maps = await db!
        .query("Igrac", columns: null, where: "id = ?", whereArgs: [id]);

    return Player.fromDb(maps.first);
  }

  Future<Contestant> fetchContestantById(int id) async {
    print('PREDAT id za uzimanje igraca za izvlacenje imena $id');
    final maps = await db!
        .query("Ucesnik", columns: null, where: "id = ?", whereArgs: [id]);

    return Contestant.fromDb(maps.first);
  }

  Future<Player> fetchPlayerByName(String name) async {
    final maps = await db!
        .query("Igrac", columns: null, where: "ime = ?", whereArgs: [name]);

    return Player.fromDb(maps.first);
  }

  addPlayer(Player player) async {
    return db!.insert("Igrac", player.toMap());
  }

  addContestant(Contestant contestant) async {
    return db!.insert("Ucesnik", contestant.toMap());
  }

  deleteContestant(int id) async {
    return db!.delete("Ucesnik",where: "id = ?", whereArgs: [id]);
  }

  addTournament(Tournament tournament) async {
    return db!.insert("Turnir", tournament.toMap());
  }

  addGame(Game game) async {
    return db!.insert("Rezultat", game.toMap());
  }

  Future<int> nextPlayerId() async {
    List<Player> players = await dbProvider.fetchAllPlayers();

    if (players.length == 0) return 1;
    int? maxId = players[0].id;
    for (int i = 0; i < players.length; i++) {
      if ((players[i].id as int) > (maxId as int)) maxId = players[i].id;
    }

    return (maxId as int)+1;
  }

  Future<int> nextTournamentId() async {
    List<Tournament> tournaments = await dbProvider.fetchAllTournaments();

    if (tournaments.length == 0) {
      print('FIRST TOURNAMENT!');
      return 1;
    }
    int? maxId = tournaments[0].id;
    for (int i = 0; i < tournaments.length; i++) {
      if ((tournaments[i].id as int) > (maxId as int))
        maxId = tournaments[i].id;
    }

    return (maxId as int)+1;
  }

  Future<int> nextContestantId() async {
    List<Contestant> contestants = await dbProvider.fetchAllContestants();

    if (contestants.length == 0)
      return 1;
    int? maxId = contestants[0].id;
    for (int i = 0; i < contestants.length; i++) {
      if ((contestants[i].id as int) > (maxId as int))
        maxId = contestants[i].id;
    }

    return (maxId as int)+1;
  }

  Future<int> nextGameId() async{
    List<Game> games = await dbProvider.fetchAllGames();
    if(games.length==0)
      return 1;

    int? maxId = games[0].id;
    for (int i = 0; i < games.length; i++) {
      if ((games[i].id as int) > (maxId as int))
        maxId = games[i].id;
    }

    return (maxId as int)+1;

  }
}

final DbProvider dbProvider = DbProvider();
