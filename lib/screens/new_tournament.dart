import 'package:flutter/material.dart';
import '../src/blocs/bloc.dart';
import '../src/resources/db_provider.dart';
import '../src/model/tournament.dart';
import 'package:intl/intl.dart';


class NewTournament extends StatelessWidget{
  Widget build(context){
    return FutureBuilder(
        future: dbProvider.nextTournamentId(),
        builder: (context1,snapshot){
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Center(child: CircularProgressIndicator());
          }
          if((snapshot.data as int)==null)
            return Center(child: CircularProgressIndicator());

          String formatedDate = DateFormat('d MMM yyyy kk:mm:ss').format(DateTime.now());
          Tournament tournament = Tournament(snapshot.data as int,formatedDate);
          print('INSERTED TOURNAMENT ID : ${tournament.id}');
          dbProvider.addTournament(tournament);
          bloc.setCurrentTournamentId(snapshot.data as int);
          return Container(
        margin: EdgeInsets.all(50.0),
        child: Column(
          children: [
            playerField1(),
            playerField2(),
            playerField3(),
            submitButton(),
          ],
        )
    );

          }
    );
  }

  Widget playerField1() {
    return StreamBuilder(
        stream: bloc.player1Name,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePlayer1,
            decoration: InputDecoration(
                hintText: 'Igrač 1',
                labelText: 'Igrač 1',
                errorText: snapshot.error as String?
            ),
          );
        }
    );
  }

  Widget playerField2(){
      return StreamBuilder(
          stream: bloc.player2Name,
          builder: (context,snapshot){
            return TextField(
              onChanged: bloc.changePlayer2,
              decoration: InputDecoration(
                  hintText: 'Igrač 2',
                  labelText: 'Igrač 2',
                  errorText: snapshot.error as String?
              ),
            );
          }
      );
  }

  Widget playerField3(){
    return StreamBuilder(
        stream: bloc.player3Name,
        builder: (context,snapshot){
          return TextField(
            onChanged: bloc.changePlayer3,
            decoration: InputDecoration(
                hintText: 'Igrač 3',
                labelText: 'Igrač 3',
                errorText: snapshot.error as String?
            ),
          );
        }
    );
  }

  Widget submitButton(){
    return StreamBuilder(
       stream: bloc.submitValid,
        builder: (context,snapshot){
          return ElevatedButton(
          onPressed: snapshot.hasData ? (){bloc.submitContestants(context, bloc.currentTournamentId);}:null,
          child: Text('Potvrdi'),
          );
        },
    );
  }


}