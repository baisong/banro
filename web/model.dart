library model;
import 'dart:math';
import 'board.dart';

class Game {

  List<String> resources;
  List<int> probs;
  List<Tile> tiles;

  String printBoard() {

    String board = blankBoard();

    for (Tile tile in tiles) {
      board = board.replaceFirst('###', '$tile');
    }

    return board;
  }

  Game.initBoard() {
    this.tiles = [];
    this.resources = shuffle(['W','W','W','W','L','L','L','L','S','S','S','S','I','I','I','B','B','B','X']);
    this.probs = shuffle([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12]);

    int probability = 0;

    int j = 0;
    int len = this.resources.length;
    for (int i = 0; i < len; i++) {
      if (this.resources[i] != 'X') {
        probability = this.probs[j];
        j++;
      }
      else {
        probability = 0;
      }
      var tile = new Tile(resources[i], probability);
      this.tiles.add(tile);
    }
  }
}

class Piece {
  String textSymbol;
  int position;
  String id;
  //Piece(this.textSymbol);
}

class Tile extends Piece {
  List<String> edges;
  List<String> nodes;
  String resource;
  int probability;

  Tile(String resource, int probability) {
    this.resource = resource;
    this.probability = probability;
    String buffer = probability < 10 ? '0' : '';
    this.textSymbol = '${resource}${buffer}${probability}';
  }
  String toString() => '${textSymbol}';
}

class Edge extends Piece {
  List<String> nodes;
}

class Node extends Piece {
  List<String> edges;
}

// Shuffle a list randomly.
List shuffle(List list) {
  int len = list.length - 1;
  for (int i = len; i >= 0; i--) {
    // Generates a new random value.
    var random = new Random();
    int swap = random.nextInt(len);

    // Swaps two values; [:i:] and the random [:swap:]
    Object tmp = list[i];
    list[i] = list[swap];
    list[swap] = tmp;
  }
  return list;
}