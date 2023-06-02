// Util Classes.

enum PieceState {
  empty,
  black,
  white,
}

enum Direction {
  up,
  down,
  left,
  right,
}

class Coordinates {
  late int row;
  late int col;

  Coordinates(this.row, this.col);

  Coordinates.copy(Coordinates other) {
    row = other.row;
    col = other.col;
  }

  @override
  String toString() {
    return '($row, $col)';
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinates && other.row == row && other.col == col;

  @override
  int get hashCode => row.hashCode + col.hashCode;

  Coordinates translate(Direction dir, int val) {
    Coordinates dest = Coordinates.copy(this);

    switch (dir) {
      case Direction.up:
        dest.row -= val;
      case Direction.down:
        dest.row += val;
      case Direction.left:
        dest.col -= val;
      case Direction.right:
        dest.col += val;
    }

    return dest;
  }
}

// Helpers.

PieceState getOpponent(PieceState player) {
  if (player == PieceState.empty) {
    throw ArgumentError('player cannot be empty');
  }

  return player == PieceState.black ? PieceState.white : PieceState.black;
}

String playerAsString(PieceState player) {
  assert(player != PieceState.empty);
  return player == PieceState.black ? "Black" : "White";
}
