import 'package:flutter/material.dart';

import '../src/resources/db_provider.dart';
import '../src/blocs/bloc.dart';

class PlayerStats extends StatelessWidget {
  build(context) {
    return Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
      children: [
        // Akumulirani broj odigranih turnira

        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider.fetchNumberOfTournamentsFromPlayer(
              bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if ((snapshot.data as int) == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Text("BROJ ODIGRANIH TURNIRA : ${snapshot.data}");
          },
        )),

        //Broj prvih mesta

        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider.fetchNumberOffFirstPositions(
              bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("BROJ PRVIH MESTA : ${snapshot.data}");
          },
        )),

        //Broj drugih mesta

        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider.fetchNumberOffSecondPositions(
              bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("BROJ DRUGIH MESTA : ${snapshot.data}");
          },
        )),

        //Broj trecih mesta

        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider.fetchNumberOffThirdPositions(
              bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("BROJ TRECIH MESTA : ${snapshot.data}");
          },
        )),

        //Akumulirani broj postignutih golova
        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider
              .fetchTotalGoalsScored(bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("BROJ POSTIGNUTIH GOLOVA  : ${snapshot.data}");
          },
        )),

        //Akuimulirani broj primljenih golova

        Expanded(
            child: FutureBuilder<int>(
          future: dbProvider
              .fetchTotalGoalsAllowed(bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("BROJ PRIMLJENIH GOLOVA : ${snapshot.data}");
          },
        )),

        //Akumulirani procenat pobeda

        Expanded(
            child: FutureBuilder<double>(
          future: dbProvider
              .playerWinningPercentage(bloc.currentPlayerIdToSeeDetails as int),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Text("PROCENAT POBEDA : ${(snapshot.data)!.toStringAsFixed(2)}%");
          },
        )),
      ],
    ));
  }
}
