// Auto-generated from index.html.
// DO NOT EDIT.

library index_html;

import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;

import 'game.html.dart';
import 'board.html.dart';


// Original code
main(){}
        

// Additional generated code
void init_autogenerated() {
  var _root = autogenerated.document.body;
  var __actions, __e0, __e1, __stats;

  var __t = new autogenerated.Template(_root);
  __e1 = _root.query('#__e-1');
  __e0 = __e1.query('#__e-0');
  new Board.forElement(__e0);
  __t.component(__e0);
  new Game.forElement(__e1);
  __t.component(__e1);
  __stats = _root.query('#stats');
  __actions = _root.query('#actions');
  

  __t.create();
  __t.insert();
}
