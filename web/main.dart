import 'model.dart';

String curTime;
String boardString;
String statsString;

main() {
  Game game = new Game();
  boardString = game.printBoard();
  statsString = game.printStats();

  var today = new Date.now();
  curTime = '${today.hour}:${today.minute} XM';
}