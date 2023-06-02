import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:konane/components/board.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/components/space.dart';
import 'package:konane/components/src/board_controller.dart';
import 'package:konane/components/src/board_model.dart';
import 'package:konane/components/text_pane.dart';
import 'package:konane/utils/board_consts.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:konane/utils/visual_consts.dart';

class KonaneGame extends FlameGame {
  late final BoardController controller;
  late final BoardModel model;
  late final World world;

  late final ThemeData theme;

  KonaneGame(this.theme);

  @override
  Color backgroundColor() => gameBackgroundColor;

  @override
  FutureOr<void> onLoad() {
    model = BoardModel(Settings.boardSize);
    controller = BoardController(model);

    var pieces = [
      for (var r = 0; r < Settings.boardSize; r++)
        for (var c = 0; c < Settings.boardSize; c++)
          Piece(PieceState.values[(c % 2 + r % 2) % 2 + 1], Coordinates(r, c))
            ..size = pieceSize
            ..priority = 3
    ];

    List<Space> spaces = [];
    for (var piece in pieces) {
      var space = Space(piece.coords)
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

    // TODO(yvangieson): allow choosing the pieces to remove to start
    pieces.removeWhere((piece) =>
        piece.coords == Coordinates(3, 3) || piece.coords == Coordinates(4, 3));
    model.setPieceState(Coordinates(3, 3), PieceState.empty);
    model.setPieceState(Coordinates(4, 3), PieceState.empty);

    Vector2 boardSize = Vector2.all(boardPadding * 2 +
        (spaceGap * (Settings.boardSize - 1)) +
        spaceRadius * 2 * Settings.boardSize);
    final board = Board(spaces)
      ..size = boardSize
      ..position = Vector2.all(gamePadding)
      ..priority = 1;

    Vector2 textPaneSize = Vector2(boardSize.x, textPaneHeight);
    final textPane = TextPane()
      ..size = textPaneSize
      ..position = Vector2(gamePadding, gamePadding * 2 + boardSize.y)
      ..priority = 1;

    world = World()
      ..add(board)
      ..addAll(spaces)
      ..addAll(pieces)
      ..add(textPane);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          boardSize + Vector2(0, textPaneHeight) + Vector2.all(gamePadding * 4)
      ..viewfinder.position = Vector2(boardSize.x / 2 + gamePadding, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);

    controller.startGame();

    return super.onLoad();
  }

  void updatePieces() {
    world.removeWhere((component) =>
        component is Piece &&
        model.getPieceState(component.coords) == PieceState.empty);
  }
}
