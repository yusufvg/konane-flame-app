import 'package:flame/components.dart';
import 'package:konane/utils/board_utils.dart';

class Piece extends PositionComponent {
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

  // Methods.
}
