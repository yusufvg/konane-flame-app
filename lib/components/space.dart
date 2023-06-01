import 'dart:ui';

import 'package:flame/components.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:konane/utils/visual_consts.dart';

class Space extends PositionComponent {
  final Coordinates coords;
  Piece? piece;

  Space(this.coords);

  Space.fill(this.coords, Piece piece) {
    acquirePiece(piece);
  }

  // Getters, setters.

  bool get isEmpty => piece == null;

  PieceState get state => piece != null ? piece!.state : PieceState.empty;

  // Event handlers.

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(const Offset(spaceRadius, spaceRadius), spaceRadius,
        Paint()..color = spaceColor);
  }

  // Methods.

  void acquirePiece(Piece piece) {
    assert(isEmpty);

    this.piece = piece;
    piece.coords = coords;
  }

  void removePiece() {
    assert(!isEmpty);

    piece = null;
  }

  bool hasPiece(Piece piece) {
    return !isEmpty && this.piece == piece;
  }
}
