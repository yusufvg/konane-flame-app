import 'package:konane/utils/board_utils.dart';

class BoardModel {
  late Map<Coordinates, PieceState> spaces;

  late int _size;

  /// Initializes the model with a default board size of 8.
  ///
  /// The optional parameter [size] can be used to increase the size of the board.
  /// Throws an [ArgumentError] if the size is set to smaller than 8.
  BoardModel([int size = 8]) {
    if (size < 8) {
      throw ArgumentError('board size cannot be smaller than 8: $size');
    }

    _size = size;

    spaces = {};

    for (int r = 0; r < size; r++) {
      PieceState nextState = r % 2 == 0 ? PieceState.black : PieceState.white;
      for (int c = 0; c < size; c++) {
        Coordinates coords = Coordinates(r, c);
        spaces[coords] = nextState;
        nextState =
            nextState == PieceState.black ? PieceState.white : PieceState.black;
      }
    }
  }

  int get size => _size;

  /// Retrieves the [PieceState] at the given [Coordinates].
  ///
  /// Throws an [ArgumentError] if [coords] are invalid or missing in the board.
  PieceState getPieceState(Coordinates coords) {
    if (!isValidCoordinate(coords)) {
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');
    }

    return spaces.containsKey(coords)
        ? spaces[coords]!
        : throw ArgumentError(
            'coordinates not found in board: ${coords.row}, ${coords.col}');
  }

  /// Sets the [PieceState] at the given [Coordinates].
  ///
  /// Throws an [ArgumentError] if coords are invalid or missing in the board.
  void setPieceState(Coordinates coords, PieceState state) {
    if (!isValidCoordinate(coords)) {
      throw ArgumentError('invalid coordinates: ${coords.row}, ${coords.col}');
    }

    PieceState currentState = getPieceState(coords);
    if (state == currentState) return;

    spaces[coords] = state;
  }

  /// Checks whether the given player has any valid moves remaining.
  ///
  /// Throws an [ArgumentError] if the [PieceState] provided is empty.
  bool hasValidMoves(PieceState player) {
    if (player == PieceState.empty) {
      throw ArgumentError('invalid player value: $player');
    }

    PieceState other =
        player == PieceState.black ? PieceState.white : PieceState.black;

    return _getPiecesFor(player).keys.any((coords) {
      bool result = false;
      for (var dir in Direction.values) {
        if (!result &&
            isValidCoordinate(coords.translate(dir, 2)) &&
            spaces[coords.translate(dir, 1)] == other &&
            spaces[coords.translate(dir, 2)] == PieceState.empty) result = true;
      }

      return result;
    });
  }

  /// Checks whether the given [Coordinates] are valid based on the current size of the board.
  ///
  /// Returns false for negative values or values outside the bounds of the board, and true otherwise.
  bool isValidCoordinate(Coordinates coords) {
    return (coords.row >= 0 && coords.row < _size) &&
        (coords.col >= 0 && coords.col < _size);
  }

  // Helpers.

  Map<Coordinates, PieceState> _getPiecesFor(PieceState player) {
    assert(player != PieceState.empty);

    Map<Coordinates, PieceState> piecesFor = Map.from(spaces);
    piecesFor.removeWhere((key, value) => value != player);

    return piecesFor;
  }
}
