import 'dart:async';


class NameValidators {
  final validatePlayer1 = StreamTransformer<String,String>.fromHandlers(
      handleData: (player1,sink){
        if(player1.length > 0)
          sink.add(player1);
        else
          sink.addError('Ne sme da  bude prazno polje');
      }
  );

  final validatePlayer2 = StreamTransformer<String,String>.fromHandlers(
      handleData: (player2,sink){
        if(player2.length > 0)
          sink.add(player2);
        else
          sink.addError('Ne sme da bude prazno polje');
      }
  );

  final validatePlayer3 = StreamTransformer<String,String>.fromHandlers(
      handleData: (player3,sink){
        if(player3.length > 0)
          sink.add(player3);
        else
          sink.addError('Ne sme da bude prazno polje');
      }
  );
}