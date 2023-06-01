import 'package:flame/components.dart';
import 'package:konane/components/piece.dart';
import 'package:konane/components/space.dart';

class Board extends PositionComponent {
  final List<Space> _spaces = [];
  final int _boardSize = 8;

  Board(List<Piece> pieces, {int boardSize = 8}) {
    assert(pieces.length == boardSize * boardSize);

    for (var piece in pieces) {
      _spaces.add(Space.fill(piece.coords, piece));
    }
  }

  // Getters, setters.

  int get boardSize => _boardSize;

  // Event handlers.

  // Methods
}
