import 'package:konane/components/src/board_model.dart';
import 'package:konane/utils/board_utils.dart';

class BoardController {
  final BoardModel _boardModel;
  GameState _state = GameState.waiting;
  PieceState _winner = PieceState.empty;

  BoardController(this._boardModel);

  PieceState get currentPlayer {
    switch (_state) {
      case GameState.blacksTurn:
        return PieceState.black;
      case GameState.whitesTurn:
        return PieceState.white;
      default:
        return PieceState.empty;
    }
  }

  bool get hasGameStarted => _state != GameState.waiting;

  bool get hasGameEnded => _state == GameState.ended;

  String get gameMessage {
    if (_state == GameState.waiting) {
      return "Waiting to start.";
    } else if (_state == GameState.blacksTurn ||
        _state == GameState.whitesTurn) {
      return "It is currently ${playerAsString(currentPlayer)}'s turn.";
    } else {
      return "${playerAsString(_winner)} wins!";
    }
  }

  // TODO(yvangieson): refactor to accept removing starting pieces
  void startGame() {
    _state = GameState.blacksTurn;
  }

  /// Attempts to have the current player move their piece from [origin] to [dest],
  /// capturing any opponent pieces jumped over en route.
  ///
  /// Returns false if the move is not legal (e.g. invalid coords, diagonal jump, destination occupied, etc.).
  /// Returns true if the move was successfully completed. In this case, the current player is updated to the opponent.
  ///
  /// Asserts that the game has started and not ended.
  bool makeMove(Coordinates origin, Coordinates dest) {
    assert(hasGameStarted && !hasGameEnded);

    // invalid coordinates
    if (!_boardModel.isValidCoordinate(origin) ||
        !_boardModel.isValidCoordinate(dest)) {
      return false;
    }

    // illegal diagonal move
    if (origin.row != dest.row && origin.col != dest.col) return false;

    // determine intermidiate spaces
    Map<Coordinates, PieceState> intermediateSpaces = {};
    if (origin.row == dest.row) {
      if ((dest.col - origin.col).abs() % 2 != 0) return false;

      int start, end;
      if (dest.col > origin.col) {
        start = origin.col;
        end = dest.col;
      } else {
        start = dest.col;
        end = origin.col;
      }
      for (int i = start + 1; i < end; i += 2) {
        Coordinates intermediate = Coordinates(origin.row, i);
        intermediateSpaces[intermediate] =
            _boardModel.getPieceState(intermediate);
      }
    } else {
      if ((dest.row - origin.row).abs() % 2 != 0) return false;

      int start, end;
      if (dest.row > origin.row) {
        start = origin.row;
        end = dest.row;
      } else {
        start = dest.row;
        end = origin.row;
      }
      for (int i = start + 1; i < end; i += 2) {
        Coordinates intermediate = Coordinates(i, origin.col);
        intermediateSpaces[intermediate] =
            _boardModel.getPieceState(intermediate);
      }
    }

    // pieces in illegal state
    if (_boardModel.getPieceState(dest) != PieceState.empty ||
        _boardModel.getPieceState(origin) != currentPlayer) return false;
    for (PieceState state in intermediateSpaces.values) {
      if (state == PieceState.empty) return false;
    }

    // make the move
    _boardModel.setPieceState(origin, PieceState.empty);
    _boardModel.setPieceState(dest, currentPlayer);
    for (Coordinates coords in intermediateSpaces.keys) {
      _boardModel.setPieceState(coords, PieceState.empty);
    }
    _state = _state == GameState.blacksTurn
        ? GameState.whitesTurn
        : GameState.blacksTurn;

    // check for winner
    if (!hasValidMoves()) {
      _winner = getOpponent(currentPlayer);
      _state = GameState.ended;
    }

    return true;
  }

  /// Checks whether or not the currently active player has any valid moves remaining.
  bool hasValidMoves() {
    return _boardModel.hasValidMoves(currentPlayer);
  }
}

enum GameState {
  waiting,
  blacksTurn,
  whitesTurn,
  ended,
}
