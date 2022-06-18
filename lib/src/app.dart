import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/new_tournament.dart';
import '../screens/fixtures.dart';
import '../screens/rankings.dart';
import '../screens/new_player.dart';
import '../screens/players_list.dart';
import '../screens/all_results.dart';
import '../screens/results_for_tournament.dart';
import '../screens/table_for_tournament.dart';
import '../screens/player_stats.dart';

class App extends StatelessWidget {
  build(context) {
    return MaterialApp(
      title: "FIFA TOURNAMENT",
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
              ),
              child: HomePage(),
          )

        );
      });
    }
    if (settings.name!.endsWith('/new_tournament')) {
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
            ),
            child: NewTournament(),
          )
        );
      });
    }
    if(settings.name!.endsWith('/fixtures')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body:Container(
              decoration: BoxDecoration(
                image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
              ),
              child: Results(),
            ),
        );
      });
    }
    if(settings.name!.endsWith('/rankings')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
            image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
        ),
            child:RankingsTable()),
        );
      });
    }
    if(settings.name!.endsWith('/new_player')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
            image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
        ),
        child:NewPlayer()),
        );
      });
    }
    if(settings.name!.endsWith('/players_list')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
            image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
        ),
        child:PlayersList()),
        );
      });
    }

    if(settings.name!.endsWith('/results')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Container(
              decoration: BoxDecoration(
        image: DecorationImage( image: AssetImage("assets/images/back_ground_image.jpg"),fit:  BoxFit.cover),
        ),
        child:AllResults(),))
        )
        );
      });
    }

    if(settings.name!.endsWith('/results_for_tour')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
            body: ResultsForTournament(),
            );
      });
    }

    if(settings.name!.endsWith('/table_for_tour')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: TableForTournament(),
        );
      });
    }

    if(settings.name!.endsWith('/player_stats')){
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: PlayerStats(),
        );
      });
    }

    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: HomePage(),
      );
    });
  }
}
