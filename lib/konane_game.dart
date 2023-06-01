import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:konane/components/board.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/components/space.dart';
import 'package:konane/utils/board_consts.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:konane/utils/visual_consts.dart';

class KonaneGame extends FlameGame {
  @override
  Color backgroundColor() => gameBackgroundColor;

  @override
  FutureOr<void> onLoad() {
    final pieces = [
      for (var r = 0; r < Settings.boardSize; r++)
        for (var c = 0; c < Settings.boardSize; c++)
          Piece(PieceState.values[(c % 2 + r % 2) % 2 + 1], Coordinates(r, c))
            ..size = pieceSize
            ..priority = 3
    ];

    List<Space> spaces = [];
    for (var piece in pieces) {
      var space = Space.fill(piece.coords, piece)
        ..size = spaceSize
        ..position = Vector2(
            gamePadding +
                boardPadding +
                piece.coords.row * (spaceGap + spaceRadius * 2),
            gamePadding +
                boardPadding +
                piece.coords.col * (spaceGap + spaceRadius * 2))
        ..priority = 2;
      piece.position = space.position + Vector2.all(spacePadding);
      spaces.add(space);
    }

    Vector2 boardSize = Vector2.all(boardPadding * 2 +
        (spaceGap * (Settings.boardSize - 1)) +
        spaceRadius * 2 * Settings.boardSize);
    final board = Board(spaces)
      ..size = boardSize
      ..position = Vector2.all(gamePadding)
      ..priority = 1;

    final world = World()
      ..add(board)
      ..addAll(spaces)
      ..addAll(pieces);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = boardSize + Vector2.all(gamePadding * 2)
      ..viewfinder.position = Vector2(boardSize.x / 2 + gamePadding, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);

    return super.onLoad();
  }
}
