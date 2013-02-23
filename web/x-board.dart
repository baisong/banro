import 'package:web_ui/web_ui.dart';
import 'dart:math';
import 'dart:html';

/**
 * Represents one game from start to finish.
 */
class xBoard extends WebComponent {
  Board board;
  created() {
    board  = new Board();
    var boardChildNode = board.toElement();
    document.nodes.add(boardChildNode);
  }
}

/**
 *
 */
class Board {

  List<String> resources;
  List<int> probs;
  List<Tile> tiles;
  List<Section> stats;

  /**
   * Initializes a board.
   */
  String blankBoard() {
    String boardString = '''+-------------------------------------------------+
  |                        -                        |
  |                     /     \\                     |
  |                  -           -                  |
  |               /     \\     /     \\               |
  |            -         o - o         -            |
  |         /     \\     /     \\     /     \\         |
  |      -         o - o ##### o - o         -      |
  |   /     \\     /     \\     /     \\     /     \\   |
  |          o - o ##### o - o ##### o - o          |
  |   \\     /     \\     /     \\     /     \\     /   |
  |      - o ##### o - o ##### o - o ##### o -      |
  |   /     \\     /     \\     /     \\     /     \\   |
  |          o - o ##### o - o ##### o - o          |
  |   \\     /     \\     /     \\     /     \\     /   |
  |      - o ##### o - o ##### o - o ##### o -      |
  |   /     \\     /     \\     /     \\     /     \\   |
  |          o - o ##### o - o ##### o - o          |
  |   \\     /     \\     /     \\     /     \\     /   |
  |      - o ##### o - o ##### o - o ##### o -      |
  |   /     \\     /     \\     /     \\     /     \\   |
  |          o - o ##### o - o ##### o - o          |
  |   \\     /     \\     /     \\     /     \\     /   |
  |      -         o - o ##### o - o         -      |
  |         \\     /     \\     /     \\     /         |
  |            -         o - o         -            |
  |               \\     /     \\     /               |
  |                  -           -                  |
  |                     \\     /                     |
  |                        -                        |
  +-------------------------------------------------+''';
    var br = new BRElement();
    boardString.replaceAll(' ', '&nbsp;');
    boardString.replaceAll('\\n', br.toString());
    return boardString;
  }
  /**
   * Initializes a board again.
   */
  Element toElement() {
    var div = new DivElement();
    String boardString = blankBoard();
    List<String> textParts = boardString.split('#####');
    div.insertAdjacentText('beforeEnd', textParts.removeAt(0));
    for (Tile tile in tiles) {
      div.insertAdjacentElement('beforeEnd', tile.toElement());
      boardString = boardString.replaceFirst('#####', '$tile');
    }
  }
  /**
   * Prints a text-only visualization of the game board.
   */
  String toString() {
    String boardString = blankBoard();
    for (Tile tile in tiles) {
      boardString = boardString.replaceFirst('#####', '$tile');
    }
    return boardString;
  }
  
  /**
   * Sets up a new random board.
   */
  Board() {
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
      Tile tile = new Tile(resources[i], probability);
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
    Map<String, dynamic> totals = {};
    Map<String, dynamic> counts = {};
    Map<String, dynamic> averages = {};
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
    var span = toElement();
    String buffer = '';
    
    if (proportion % 2 == 0) {
      buffer = '&nbsp;';
    }

    return '${span.outerHtml}${buffer}';
  }
  
  Element toElement() {
    String output = '';
    String classString = '';
    var span = new SpanElement();
    String text = '';
    
    if (proportion == null) {
      proportion = 0;
    }

    for (int i = 0; i < proportion; i++) {
      text = '${text}${resource}';
    }
    classString = "resource-${resource.toLowerCase()}";
    span.classes.add(classString);
    
    int width = proportion;
    while (width < 4) {
      text = ' ${text} ';
      width = width + 2;
    }
    span.text = text;
    return span;
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
    Random random = new Random();
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