import 'package:konane/components/src/board_model.dart';
import 'package:konane/utils/board_utils.dart';

// Helpers.

void setBoardState(BoardModel model, String board) {
  int r = 0;
  for (String row in board.split('\n')) {
    int c = 0;
    for (String space in row.split('')) {
      PieceState state;
      switch (space) {
        case 'b':
          state = PieceState.black;
        case 'w':
          state = PieceState.white;
        default:
          state = PieceState.empty;
      }

      model.setPieceState(Coordinates(r, c), state);
      c++;
    }
    r++;
  }
}
