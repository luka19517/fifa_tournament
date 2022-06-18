import 'package:flutter/material.dart';
import '../src/resources/db_provider.dart';
import '../src/model/tournament.dart';
import '../src/blocs/bloc.dart';

class AllResults extends StatelessWidget{
  build(context){
    return  FutureBuilder<List<Tournament>>(
            future: dbProvider.fetchAllTournaments(),
            builder: (context,snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              }
              if ((snapshot.data as List<Tournament>) == null)
                return Center(child: CircularProgressIndicator());

              return Center(
                  child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  height: 1000.0,
                  width: 600.0,
                  child: Column(
                      children: [
                        Text('Odigrani turniri',
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white)),
                        Container(height: 50.0,),
                        for(var tournament in (snapshot.data as List<
                            Tournament>))
                          Column(
                              children:
                              [
                                Row(
                                  children: [
                                    Expanded(
                                      child:Container(
                                        color: Color.fromRGBO(5, 5, 5, 0.15),
                                        width: 80.0,
                                        child: Text('${tournament.date}',style:TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                    Expanded(child: Container(child:tableButton(context,tournament.id))),
                                    Expanded(child: Container(child:fixturesButton(context,tournament.id))),
                                  ],
                                ),
                                Container(height: 10.0,)
                            ]
                          ),
                      ]

                  )
              )
              );
            }
              );
  }

  tableButton(context,tournamentId){
    return Container(
        height: 40.0,
        width: 20.0,
        child:ElevatedButton(
        onPressed: (){
          bloc.setCurrentTournamentIdToSeeDetails(tournamentId);
          Navigator.pushNamed(context, '/table_for_tour');
        },
        child: Text('Tabela'))
    );
  }

  fixturesButton(context,tournamentId){
    return Container(
        height: 40.0,
        width: 20.0,
        child:ElevatedButton(
        onPressed: (){
          bloc.setCurrentTournamentIdToSeeDetails(tournamentId);
          Navigator.pushNamed(context, '/results_for_tour');
        },
        child: Text('Rezultati'))
    );
  }
}