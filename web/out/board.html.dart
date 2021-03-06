// Auto-generated from board.html.
// DO NOT EDIT.

library x_board;

import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;

import 'package:web_ui/web_ui.dart';

class Board extends WebComponent {
  
  /** Autogenerated from the template. */
  
  /**
  * Shadow root for this component. We use 'var' to allow simulating shadow DOM
  * on browsers that don't support this feature.
  */
  var _root;
  autogenerated.Element __e14, __e7;
  autogenerated.Template __t;
  
  Board.forElement(e) : super.forElement(e);
  
  void created_autogenerated() {
    _root = createShadowRoot();
    __t = new autogenerated.Template(_root);
    _root.innerHtml = '''
    <template id="__e-7" style="display:none"></template>
    <template id="__e-14" style="display:none"></template>
    ''';
    __e7 = _root.query('#__e-7');
    __t.conditional(__e7, () => (!begun), (__t) {
      var __e6, __xBoard;
      __xBoard = new autogenerated.Element.html('<div id="x-board" class="span6">\n          <h3>New board</h3>\n          <button class="btn btn-primary pull-right" id="__e-6">Begin game</button>\n          <p>this new game has not yet started.</p>\n          <content></content>\n        </div>');
      __e6 = __xBoard.query('#__e-6');
      __t.listen(__e6.onClick, ($event) { nextturn($event); });
      __t.addAll([
        new autogenerated.Text('\n        '),
        __xBoard,
        new autogenerated.Text('\n      ')
      ]);
    });
    
    __e14 = _root.query('#__e-14');
    __t.conditional(__e14, () => (begun), (__t) {
      var __e10, __e13, __e8, __xBoard;
      __xBoard = new autogenerated.Element.html('<div id="x-board" class="span6">\n          <h3>Current board</h3>\n          <button class="btn pull-right" id="__e-8">Next turn</button>\n          <p><strong id="__e-10"></strong>.\n          <template id="__e-13" style="display:none"></template></p>\n          <content></content>\n        </div>');
      __e8 = __xBoard.query('#__e-8');
      __t.listen(__e8.onClick, ($event) { nextturn($event); });
      __e10 = __xBoard.query('#__e-10');
      var __binding9 = __t.contentBind(() => (turnCount));
      __e10.nodes.addAll([
        new autogenerated.Text('turn '),
        __binding9
      ]);
      __e13 = __xBoard.query('#__e-13');
      __t.conditional(__e13, () => (turnCount > 1), (__t) {
        
        var __binding11 = __t.contentBind(() => (turnCount-1));
        var __binding12 = __t.contentBind(() => (lastTurnDuration.inSeconds));
        __t.addAll([
          new autogenerated.Text('turn '),
          __binding11,
          new autogenerated.Text(' lasted '),
          __binding12,
          new autogenerated.Text(' seconds.')
        ]);
      });
      
      __t.addAll([
        new autogenerated.Text('\n        '),
        __xBoard,
        new autogenerated.Text('\n      ')
      ]);
    });
    
    __t.create();
  }
  
  void inserted_autogenerated() {
    __t.insert();
  }
  
  void removed_autogenerated() {
    __t.remove();
    __e14 = __e7 = __t = null;
  }
  
  void composeChildren() {
    super.composeChildren();
    if (_root is! autogenerated.ShadowRoot) _root = this;
  }
  
  /** Original code from the component. */
  
  bool begun = false;
  int turnCount = 0;
  var turnStartTime = new DateTime.now();
  var turnEndTime = new DateTime.now();
  var lastTurnDuration = new Duration();
  
  void nextturn(e, {bool reset: false}) {
    turnEndTime       = new DateTime.now();
    lastTurnDuration  = turnEndTime.difference(turnStartTime);
    turnStartTime     = turnEndTime;
    turnCount++;
    
    if (reset) {
      turnCount = 0;
    }
    if (turnCount > 0) {
      begun = true;
    }
  }
}

