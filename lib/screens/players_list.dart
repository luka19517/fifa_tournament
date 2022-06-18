import 'package:flutter/material.dart';
import '../src/model/player.dart';
import '../src/resources/db_provider.dart';
import '../src/blocs/bloc.dart';

class PlayersList extends StatelessWidget {
  build(context) {
    return  Container(
        child:FutureBuilder<List<Player>>(
            future: dbProvider.fetchAllPlayers(),
            builder: (context1, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              }
              if(snapshot.data==null)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Container(
                  child: Column(
                    children: [
                      for (var player in (snapshot.data as List<Player>))
                        Expanded(
                            child: Row(
                                children:[
                                  Container( child: Text('${player.ime}', style: TextStyle(fontSize: 20.0),),margin: EdgeInsets.all(20.0),),
                                  Container( child: statsButton(context,player.id as int),margin: EdgeInsets.all(20.0),),
                                ]
                            )
                        )
                    ],
                  ));
            })
    );
  }

  statsButton(context,int playerId){
    return Container(
      child: ElevatedButton(
        child: Text('STATISTIKA'),
        onPressed: (){
          bloc.setCurrentPlayerIdToSeeDetails(playerId);
          Navigator.pushNamed(context, '/player_stats');
        } ,
      )
    );
  }
}
