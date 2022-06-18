import 'package:fifa_tournament/src/resources/db_provider.dart';
import 'package:flutter/material.dart';
import '../src/model/tournament.dart';
import '../src/blocs/bloc.dart';
import '../src/resources/db_provider.dart';

class HomePage extends StatelessWidget {
  Widget build(context) {
    dbProvider.init();
    return Center(
        child: Container(
            height: 600.0,
            width: 400.0,
            margin: EdgeInsets.all(30.0),
            child: Column(children: [
              Text('FIFA TURNIR',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white)),
              Container(
                margin: EdgeInsets.all(30.0),
              ),
              Row(
                children: [
                  Container(child: newTournamentButton(context), height: 170.0,width: 170,),
                  Container(width: 10.0,),
                  Container(child: newPlayerButton(context),height: 170.0, width: 170.0)
                ],
              ),
              Container(
                margin: EdgeInsets.all(20.0),
              ),
              Row(
                children: [
                  Container(child: resultsButton(context), height: 170.0,width: 170.0,),
                  Container(width: 10.0,),
                  Container(child: playersButton(context),height: 170.0, width: 170.0)
                ],
              ),
            ])));
  }

  newTournamentButton(context) {
    return
          SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color.fromRGBO(5, 5, 5,0.3)) ,
                  onPressed: () {
                    Navigator.pushNamed(context, '/new_tournament');
                  },
                  child: Text('Novi turnir')),
              width: 200.0,
              height: 80.0
          );

  }

  resultsButton(context) {
    return SizedBox(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color.fromRGBO(5, 5, 5,0.3)) ,
          onPressed:() { Navigator.pushNamed(context, '/results');}, child: Text('Rezultati')),
      width: 200.0,
      height: 80.0,
    );
  }

  playersButton(context) {
    return SizedBox(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color.fromRGBO(5, 5, 5,0.3)) ,
            onPressed: () {

          Navigator.pushNamed(context, '/players_list');
        }, child: Text('Lista igraca')),
        width: 200.0,
        height: 80.0
    );
  }

  newPlayerButton(context) {
    return SizedBox(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color.fromRGBO(5, 5, 5,0.3)) ,
            onPressed: () {
              //TODO u dodeliti slog u tabeli Igrac sa novim idjem
              Navigator.pushNamed(context, '/new_player');
            },
            child: Text('Nov igrac')),
        width: 200.0,
        height: 80.0
    );
  }
}
