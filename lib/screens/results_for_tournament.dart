import 'package:flutter/material.dart';
import '../src/resources/db_provider.dart';
import '../src/blocs/bloc.dart';
import '../src/model/game.dart';
import '../src/model/player.dart';
import '../src/model/contestant.dart';

class ResultsForTournament extends StatelessWidget {
  build(context) {
    return Container(
        margin: EdgeInsets.all(40.0),
        child: FutureBuilder<List<Game>>(
            future: dbProvider.fetchGamesFromTournament(
                bloc.currentTournamentIdToSeeDetails as int),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              }
              if ((snapshot.data as List<Game>) == null)
                return Center(child: CircularProgressIndicator());

              return Column(children: [
                for (Game game in (snapshot.data as List<Game>)) gameRow(game)
              ]);
            }));
  }

  gameRow(Game game) {
    return Container(
        margin: EdgeInsets.only(top:20.0),
        child:Row(
      children: [
        Expanded(
            child: FutureBuilder<Contestant>(
          future: dbProvider.fetchContestantById(game.player1 as int),
          builder: (context, snapshot1) {
            if (snapshot1.connectionState == ConnectionState.none &&
                snapshot1.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if ((snapshot1.data as Contestant) == null)
              return Center(child: CircularProgressIndicator());
            return FutureBuilder<Player>(
                future: dbProvider.fetchPlayerById(snapshot1.data!.playerId as int),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.none &&
                      snapshot2.hasData == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if ((snapshot2.data as Player) == null)
                    return Center(child: CircularProgressIndicator());
                  return Text('${snapshot2.data!.ime}', style: TextStyle(fontSize: 20.0),);
                });
          },
        )),
        Expanded(child: Text('${game.goals1}', style: TextStyle(fontSize: 20.0),)),
        Expanded(child: Text(':')),
        Expanded(child: Text('${game.goals2}', style: TextStyle(fontSize: 20.0),)),
        Expanded(
            child: FutureBuilder<Contestant>(
              future: dbProvider.fetchContestantById(game.player2 as int),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.none &&
                    snapshot1.hasData == null) {
                  return Center(child: CircularProgressIndicator());
                }
                if ((snapshot1.data as Contestant) == null)
                  return Center(child: CircularProgressIndicator());
                return FutureBuilder<Player>(
                    future: dbProvider.fetchPlayerById((snapshot1.data as Contestant).playerId as int),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState == ConnectionState.none &&
                          snapshot2.hasData == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if ((snapshot2.data as Player) == null)
                        return Center(child: CircularProgressIndicator());
                      return Text('${(snapshot2.data as Player).ime}', style: TextStyle(fontSize: 20.0),);
                    });
              },
            )),
      ],
    )
    );
  }
}
