import 'model.dart';

String curTime;
String boardString;

main() {
  var game = new Game();
  boardString = game.printBoard();

  var today = new Date.now();
  curTime = '${today.hour}:${today.minute} XM';
}