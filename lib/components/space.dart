import 'dart:js_interop';

import 'package:flame/components.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/utils/board_utils.dart';

class Space extends PositionComponent {
  final Coordinates coords;
  Piece? piece;

  Space(this.coords);

  Space.fill(this.coords, this.piece);

  // Getters, setters.

  bool get isEmpty => piece.isNull;

  PieceState get state => piece != null ? piece!.state : PieceState.empty;

  // Event handlers.

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
