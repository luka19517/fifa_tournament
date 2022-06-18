import 'package:fifa_tournament/src/model/contestant.dart';
import 'package:flutter/material.dart';
import '../src/resources/db_provider.dart';
import '../src/blocs/bloc.dart';
import '../src/model/player.dart';

class TableForTournament extends StatelessWidget {
  build(context) {
    return FutureBuilder<List<Contestant>>(
        future: dbProvider.fetchAllTournamentConestants(
            bloc.currentTournamentIdToSeeDetails as int),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Center(child: CircularProgressIndicator());
          }
          if ((snapshot.data as List<Contestant>) == null)
            return Center(child: CircularProgressIndicator());
          return Table(
            border: TableBorder.all(width: 1.0),
            children: [
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: FutureBuilder<Player>(
                            future: dbProvider.fetchPlayerById(
                                (snapshot.data as List<Contestant>)[0].playerId
                                    as int),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                      ConnectionState.none &&
                                  snapshot2.hasData == null) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if ((snapshot2.data as Player) == null)
                                return Center(
                                    child: CircularProgressIndicator());
                              return Text('${(snapshot2.data as Player).ime}', style: TextStyle(fontSize: 20.0),);
                            }))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('${snapshot.data![0].points}', style: TextStyle(fontSize: 20.0),))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            '${snapshot.data![0].goalsScored}:${snapshot.data![0].goalsAllowed}', style: TextStyle(fontSize: 20.0),)))
              ]),
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: FutureBuilder<Player>(
                            future: dbProvider.fetchPlayerById(
                                snapshot.data![1].playerId as int),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                      ConnectionState.none &&
                                  snapshot2.hasData == null) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if ((snapshot2.data as Player) == null)
                                return Center(
                                    child: CircularProgressIndicator());
                              return Text('${(snapshot2.data as Player).ime}', style: TextStyle(fontSize: 20.0),);
                            }))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('${snapshot.data![1].points}', style: TextStyle(fontSize: 20.0),))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            '${snapshot.data![1].goalsScored}:${snapshot.data![1].goalsAllowed}', style: TextStyle(fontSize: 20.0),)))
              ]),
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: FutureBuilder<Player>(
                            future: dbProvider.fetchPlayerById(
                                snapshot.data![2].playerId as int),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                      ConnectionState.none &&
                                  snapshot2.hasData == null) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if ((snapshot2.data as Player) == null)
                                return Center(
                                    child: CircularProgressIndicator());
                              return Text('${(snapshot2.data as Player).ime}', style: TextStyle(fontSize: 20.0),);
                            }))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('${snapshot.data![2].points}', style: TextStyle(fontSize: 20.0),))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            '${snapshot.data![2].goalsScored}:${snapshot.data![2].goalsAllowed}', style: TextStyle(fontSize: 20.0),)))
              ]),
            ],
          );
        });
  }
}
