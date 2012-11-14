library model;
import 'dart:math';
import 'board.dart';

/**
 * Represents one game from start to finish.
 */
class Game {

  List<String> resources;
  List<int> probs;
  List<Tile> tiles;

  List<Section> stats;

  /**
   * Prints a text-only visualization of the game board.
   */
  String printBoard() {
    String board = blankBoard();
    for (Tile tile in tiles) {
      board = board.replaceFirst('#####', '$tile');
    }
    return board;
  }

  /**
   * Sets up a new random board.
   */
  Game() {
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

    this.stats = [];
    this.stats.add(new Section('Resources', this.resourceStats()));
  }

  String printStats() {
    String output = '';
    for (var statSection in this.stats) {
      output = "$output$statSection";
    }
    return output;
  }

  String resourceStats() {
    String output = '<dl class="dl-horizontal">';
    var totals = {};
    var counts = {};
    var averages = {};
    for (var tile in this.tiles) {
      if (tile.probability < 1) {
        continue;
      }
      if (!totals.containsKey("${tile.resource}")) {
        totals["${tile.resource}"] = 0;
      }
      if (!counts.containsKey("${tile.resource}")) {
        counts["${tile.resource}"] = 0;
      }
      totals["${tile.resource}"] += tile.proportion;
      counts["${tile.resource}"] += 1;
      averages["${tile.resource}"] = totals["${tile.resource}"].toDouble() / counts["${tile.resource}"].toDouble();
    }

    final num surplus_total = 16.25;
    final num surplus_average = 4;
    final num deficit_total = 6;
    final num deficit_average = 2.5;

    for (String resource in ['b', 'i', 'l', 's', 'w']) {

      String frequency = '';
      if (totals[resource.toUpperCase()] >= surplus_total) {
        frequency = '<span class="surplus">++</span>';
      }
      else if (totals[resource.toUpperCase()] <= deficit_total) {
        frequency = '<span class="deficit">--</span>';
      }
      else {
        if (averages[resource.toUpperCase()] >= surplus_average) {
          frequency = '<span class="surplus">+</span>';
        }
        else if (averages[resource.toUpperCase()] <= deficit_average) {
          frequency = '<span class="deficit">-</span>';
        }
      }

      output = "$output<dt class=\"resource-$resource\">${resource.toUpperCase()}</dt><dd>${totals[resource.toUpperCase()]} ${frequency} </dd>";
    }

    output = "$output</dl>";

    return output;
  }
}

/**
 * Represents a generic game piece, generalizes attibutes & display
 */
class Piece {
  String textSymbol;
  int position;
  String id;
}

/**
 * Represents an individual hex-tile
 */
class Tile extends Piece {
  List<String> edges;
  List<String> nodes;
  String resource;
  int probability;
  int proportion;

  Tile(String resource, int probability) {
    this.resource = resource;
    this.probability = probability;

    Map<String, int> proportions = {
      '2' : 1,
      '3' : 2,
      '4' : 3,
      '5' : 4,
      '6' : 5,
      '8' : 5,
      '9' : 4,
      '10': 3,
      '11': 2,
      '12': 1,
    };

    this.proportion = proportions[this.probability.toString()];
    //this.textSymbol = simplePrint(this.resource, this.probability);
    this.textSymbol = this.proportionPrint();
  }

  String proportionPrint() {
    String output = '';

    if (proportion == null) {
      proportion = 0;
    }

    for (int i = 0; i < proportion; i++) {
      output = '${output}${resource}';
    }

    output = '<span class="resource-${resource.toLowerCase()}">${output}</span>';

    if (proportion % 2 == 0) {
      output = '${output}&nbsp;';
    }

    int width = proportion;
    while (width < 4) {
      output = ' ${output} ';
      width = width + 2;
    }

    return output;
  }

  String toString() => '${textSymbol}';
}

/**
 * Represents a single side of a hex, where roads are built.
 */
class Edge extends Piece {
  List<String> nodes;
}

/**
 * Represents a single corner of three edges, where cities are built.
 */
class Corner extends Piece {
  List<String> edges;
}

class Section {
  String classattr;
  String type;
  String label;
  String content;

  Section.override(this.label, this.content, this.type, this.classattr);

  Section(this.label, this.content) {
    this.type = 'h3';
    this.classattr = 'section';
  }

  String toString() {
    return "<div class=\"${this.classattr}\"><${this.type}>${this.label}</${this.type}>${this.content}</div>";
  }
}

/**
 * Shuffles a list randomly.
 */
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

String simplePrint(String resource, int probability) {
  String buffer = probability < 10 ? '0' : '';

  return ' ${resource}${buffer}${probability} ';
}
