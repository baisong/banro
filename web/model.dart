// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library model;
import 'dart:math';

class Game {

  List<String> tiles = shuffle(['W','W','W','W','L','L','L','L','S','S','S','S','I','I','I','B','B','B','X']);
  List<int> probs = shuffle([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12]);
  String printBoard() {
    String output = 'Tiles and probibilities: ';

    int len = tiles.length;
    int j = 0;
    for (int i = 0; i < len; i++) {
      output = output.concat(tiles[i]);
      if (tiles[i] != 'X') {
        output = output.concat(probs[j].toString());
        j++;
      }
      output = output.concat(',');
    }
    return output;
  }
}

// Shuffle a list randomly.
List<String> shuffle(List<String> list) {
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