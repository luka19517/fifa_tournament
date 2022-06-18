import 'package:flutter/material.dart';
import 'dart:core';
import '../src/model/contestant.dart';
import '../src/blocs/bloc.dart';
import '../src/model/game.dart';
import '../src/resources/db_provider.dart';
import '../src/model/player.dart';

class Results extends StatelessWidget {
  Widget build(context) {
    return Container(
        child: FutureBuilder<List<Contestant>>(
            future: dbProvider
                .fetchAllTournamentConestants(bloc.currentTournamentId as int),
            builder: (context, snapshot1) {
              if (snapshot1.connectionState == ConnectionState.none &&
                  snapshot1.hasData == null) {
                return Center(child: CircularProgressIndicator());
              }
              List<Game> games = [];

              if((snapshot1.data as List<Contestant>)== null )
                return Center(child: CircularProgressIndicator());

              return FutureBuilder<int>(
                  future: dbProvider.nextGameId(),
                  builder: (context,snapshot2){
                    if (snapshot2.connectionState == ConnectionState.none &&
                        snapshot2.hasData == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if((snapshot2.data as int)== null )
                      return Center(child: CircularProgressIndicator());
                    for (int i = 0; i < 9; i++) {
                      if (i % 3 == 0) {
                        games.add(Game((snapshot2.data as int)+i,(snapshot1.data as List<Contestant>)[0].id, (snapshot1.data as List<Contestant>)[1].id, 0, 0,bloc.currentTournamentId));
                      }
                      if (i % 3 == 1) {
                        games.add(Game((snapshot2.data as int)+i,(snapshot1.data as List<Contestant>)[0].id, (snapshot1.data as List<Contestant>)[2].id, 0, 0,bloc.currentTournamentId));
                      }
                      if (i % 3 == 2) {
                        games.add(Game((snapshot2.data as int)+i,(snapshot1.data as List<Contestant>)[1].id, (snapshot1.data as List<Contestant>)[2].id, 0, 0,bloc.currentTournamentId));
                      }
                    }

                    print('BROJ UCESNIKA TURNIRA IZ FIXTURES ${games.length}');

                    return Container(
                      margin: EdgeInsets.only(
                          top: 50.0, bottom: 350.0, left: 50.0, right: 50.0),
                      child: Column(children: [
                        Container(
                          child: Text(
                            'FIFA 2022 TOURNAMENT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        submitResultsButton(snapshot1.data!, games),
                        Expanded(
                            child: Container(
                              child: Column(children: [
                                for (var index in [0, 1, 2])
                                  Expanded(
                                      child: Column(children: [
                                        Expanded(child: round(index, games)),
                                        Container(margin: EdgeInsets.all(20.0)),
                                      ]))
                              ]),
                            )),
                      ]),
                    );






                  }
              );

            }
            )
    );
  }

  Widget playersNameRight(String? playerName) {
    return Text('$playerName');
  }

  Widget playersNameLeft(String? playerName) {
    return Text('$playerName');
  }

  Widget round(int roundIndex, games) {
    return Column(children: [
      for (var i in [0, 1, 2])
        Expanded(child: fixture(3 * roundIndex + i, games)),
    ]);
  }

  Widget fixture(gameIndex, List<Game> games) {
    return Row(
      children: [
        Expanded(
            child: FutureBuilder<Contestant>(
              future: dbProvider.fetchContestantById(games[gameIndex].player1 as int),
              builder:(context,snapshot1){
                  if (snapshot1.connectionState == ConnectionState.none &&
                     snapshot1.hasData == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if((snapshot1.data as Contestant) == null)
                    return Center(child: CircularProgressIndicator());
                  return FutureBuilder<Player>(
                    future: dbProvider.fetchPlayerById((snapshot1.data as Contestant).playerId as int),
                    builder: (context,snapshot2){
                      if (snapshot2.connectionState == ConnectionState.none &&
                          snapshot2.hasData == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if((snapshot2.data as Player) == null)
                        return Center(child: CircularProgressIndicator());

                      return Text(
                          '${(snapshot2.data as Player).ime}');
                    },
                  );
                  }
                  )
        ),
        Expanded(child: leftPlayerInput(gameIndex)),
        Expanded(child: Text(':')),
        Expanded(child: rightPlayerInput(gameIndex)),
        Expanded(
            child: FutureBuilder<Contestant>(
                future: dbProvider.fetchContestantById(games[gameIndex].player2 as int),
                builder:(context,snapshot1){
                  if (snapshot1.connectionState == ConnectionState.none &&
                      snapshot1.hasData == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if((snapshot1.data as Contestant) == null)
                    return Center(child: CircularProgressIndicator());
                  return FutureBuilder<Player>(
                    future: dbProvider.fetchPlayerById((snapshot1.data as Contestant).playerId as int),
                    builder: (context,snapshot2){
                      if (snapshot2.connectionState == ConnectionState.none &&
                          snapshot2.hasData == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if((snapshot2.data as Player) == null)
                        return Center(child: CircularProgressIndicator());

                      return Text(
                          '${(snapshot2.data as Player).ime}');
                    },
                  );
                }
            )
        ),
      ],
    );
  }


  Widget leftPlayerInput(int gameIndex) {
    return StreamBuilder(
        stream: bloc.homePlayer(gameIndex),
        builder: (context, snapshot) {
          return TextField(onChanged: bloc.changeHomePlayer(gameIndex));
        });
  }

  Widget rightPlayerInput(int gameIndex) {
    return StreamBuilder(
        stream: bloc.guestPlayer(gameIndex),
        builder: (context, snapshot) {
          return TextField(onChanged: bloc.changeGuestPlayer(gameIndex));
        });
  }

  Widget submitResultsButton(List<Contestant> players, List<Game> games) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return ElevatedButton(
            onPressed: snapshot.hasData
                ? () {
                    bloc.submitResults(context, players, games);
                  }
                : null,
            child: Text('Potvrdi rezultate'));
      },
    );
  }
}
