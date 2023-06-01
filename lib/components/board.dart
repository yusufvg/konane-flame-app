import 'dart:ui';

import 'package:flame/components.dart';
import 'package:konane/components/space.dart';
import 'package:konane/konane_game.dart';
import 'package:konane/utils/visual_consts.dart';

class Board extends PositionComponent with HasGameRef<KonaneGame> {
  final List<Space> spaces;
  int _boardSize = 8;

  Board(this.spaces, {int boardSize = 8}) {
    assert(spaces.length == boardSize * boardSize);

    _boardSize = boardSize;
  }

  // Getters, setters.

  int get boardSize => _boardSize;

  // Event handlers.

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(RRect.fromRectXY(size.toRect(), boardRadius, boardRadius),
        Paint()..color = boardColor);
  }

  // Methods
}
