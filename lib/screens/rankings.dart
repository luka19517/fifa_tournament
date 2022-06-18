import 'package:fifa_tournament/src/resources/db_provider.dart';
import 'package:flutter/material.dart';
import '../src/blocs/bloc.dart';
import '../src/model/contestant.dart';
import '../src/model/player.dart';


class RankingsTable extends StatelessWidget {
  build(context){
    return Container(
        margin: EdgeInsets.only(left:50.0, right:50.0, top: 300.0,bottom: 200.0),
        child: rankingsTable()

    );
  }

  Widget rankingsTable() {
    return FutureBuilder<List<Contestant>>(
        future: dbProvider.fetchAllTournamentConestants(
            bloc.currentTournamentId as int),
        builder: (context, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.none &&
              snapshot1.hasData == null) {
            return Center(child: CircularProgressIndicator());
          }
          if ((snapshot1.data as List<Contestant>) == null)
            return Center(child: CircularProgressIndicator());

          return Column(
              children: [Table(
                border: TableBorder.all(width: 1.0),
                children: [
                  TableRow(
                      children: [
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: FutureBuilder<Player>(
                                future: dbProvider.fetchPlayerById((snapshot1
                                    .data as List<Contestant>)[0]
                                    .playerId as int),
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
                                  return Text(
                                      '${(snapshot2.data as Player).ime}');
                                }
                            )
                        )
                        ), TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot1.data![0].points}'))),
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child:
                            Text('${snapshot1.data![0].goalsScored}:${snapshot1
                                .data![0].goalsAllowed}')))
                      ]
                  ),
                  TableRow(
                      children: [
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: FutureBuilder<Player>(
                                future: dbProvider.fetchPlayerById(snapshot1
                                    .data![1].playerId as int),
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
                                  return Text(
                                      '${(snapshot2.data as Player).ime}');
                                }
                            )
                        )
                        ),
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot1.data![1].points}'))),
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot1.data![1]
                                .goalsScored}:${snapshot1.data![1]
                                .goalsAllowed}')))
                      ]
                  ),
                  TableRow(
                      children: [
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: FutureBuilder<Player>(
                                future: dbProvider.fetchPlayerById(snapshot1
                                    .data![2].playerId as int),
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
                                  return Text(
                                      '${(snapshot2.data as Player).ime}');
                                }
                            )
                        )
                        ),
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot1.data![2].points}'))),
                        TableCell(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot1.data![2]
                                .goalsScored}:${snapshot1.data![2]
                                .goalsAllowed}')))
                      ]
                  ),
                ],
              ),
                Expanded(child: homeButton(context))
              ]
          );
        }
    );
  }

    homeButton(context){
      return ElevatedButton(onPressed: (){ Navigator.pop(context); Navigator.pop(context);Navigator.pop(context);}, child: Text('Nazad na pocetnu'));
    }

}