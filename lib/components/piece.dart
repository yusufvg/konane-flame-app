import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:konane/utils/visual_consts.dart';

class Piece extends PositionComponent with DragCallbacks {
  final PieceState state;
  Coordinates _coords;

  Piece(this.state, this._coords) {
    assert(state != PieceState.empty);
  }

  // Getters, setters.

  Coordinates get coords => Coordinates.copy(_coords);

  set coords(Coordinates coords) {
    _coords = Coordinates.copy(coords);
  }

  // Event handlers.

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 5;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final cameraZoom = (findGame()! as FlameGame)
        .firstChild<CameraComponent>()!
        .viewfinder
        .zoom;
    final delta = event.delta / cameraZoom;
    position.add(delta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _returnPiece();
    priority = 3;
  }

  @override
  void render(Canvas canvas) {
    if (state == PieceState.empty) {
      return;
    }

    canvas.drawCircle(
        const Offset(pieceRadius, pieceRadius),
        pieceRadius,
        Paint()
          ..color =
              state == PieceState.black ? blackPieceColor : whitePieceColor);

    canvas.drawArc(
        size.toRect(),
        0,
        pi * 2,
        false,
        Paint()
          ..color = state == PieceState.black
              ? blackPieceBorderColor
              : whitePieceBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = pieceBorderWidth);
  }

  // Methods.

  void _returnPiece() {
    position = Vector2(
            gamePadding +
                boardPadding +
                coords.row * (spaceGap + spaceRadius * 2),
            gamePadding +
                boardPadding +
                coords.col * (spaceGap + spaceRadius * 2)) +
        Vector2.all(spacePadding);
  }
}
