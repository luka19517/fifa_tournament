import '../src/resources/db_provider.dart';
import 'package:flutter/material.dart';
import '../src/blocs/bloc.dart';
import 'dart:async';

class NewPlayer extends StatelessWidget {
  int? id;

  Future<int> _getNextPlayerId() async {
    int id = await dbProvider.nextPlayerId();
    return id;
  }

  build(context) {
    return FutureBuilder<int>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data==null)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Container(
            margin: EdgeInsets.only(
                top: 50.0, bottom: 150.0, left: 100.0, right: 100.0),
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    'NEW PLAYER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Text('Igrac #id = ${snapshot.data}')),
                Expanded(child: Container(margin: EdgeInsets.all(20.0))),
                Expanded(child: newPlayerName()),
                Expanded(child: Container(margin: EdgeInsets.all(20.0))),
                Expanded(child: submitNewPlayerButton(context, id as int))
              ],
            ));
      },
      future: dbProvider.nextPlayerId(),
    );
  }

  Widget newPlayerName() {
    return StreamBuilder(
        stream: bloc.newPlayerName,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeNewPlayerName,
            decoration: InputDecoration(
                labelText: 'Ime', errorText: snapshot.error as String?),
          );
        });
  }

  Widget newPlayerBirthDate() {
    return Text('Ovde je polje za datum rodjenja');
  }

  Widget newPlayerPicture() {
    return Text('Ovde je polje za sliku');
  }

  Widget submitNewPlayerButton(context, int id) {
    return StreamBuilder(builder: (context, snapshot) {
      return ElevatedButton(
          onPressed: () {
            bloc.submitNewPlayer(context, id);
          },
          child: Text('Potvrdi'));
    });
  }
}
