import 'dart:ui';

import 'package:flame/components.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/konane_game.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:konane/utils/visual_consts.dart';

class Space extends PositionComponent with HasGameRef<KonaneGame> {
  final Coordinates coords;

  Space(this.coords);

  // Getters, setters.

  // Event handlers.

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(const Offset(spaceRadius, spaceRadius), spaceRadius,
        Paint()..color = spaceColor);
  }

  // Methods.
}
