import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:konane/konane_game.dart';
import 'package:konane/utils/visual_consts.dart';

class TextPane extends PositionComponent with HasGameRef<KonaneGame> {
  late TextComponent _gameMessage;

  @override
  FutureOr<void> onLoad() {
    _gameMessage = TextComponent(
      text: game.controller.gameMessage,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 45,
          color: game.theme.colorScheme.onPrimaryContainer,
        ),
      ),
    )
      ..anchor = Anchor.center
      ..x = size.x / 2
      ..y = size.y / 2;

    add(_gameMessage);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectXY(size.toRect(), textPaneRadius, textPaneRadius),
        Paint()..color = game.theme.colorScheme.primaryContainer);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _gameMessage.text = game.controller.gameMessage;
  }
}
