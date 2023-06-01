import 'package:konane/components/src/board_model.dart';
import 'package:konane/utils/board_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'board_test_utils.dart';

void main() {
  group('getPieceState', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('correctly retrieves initial space states', () {
      expect(model.getPieceState(Coordinates(0, 0)), equals(PieceState.black));
      expect(model.getPieceState(Coordinates(0, 1)), equals(PieceState.white));
    });

    test('throws an error for invalid coordinates', () {
      expect(
          () => model.getPieceState(Coordinates(-1, 5)), throwsArgumentError);
      expect(
          () => model.getPieceState(Coordinates(5, -1)), throwsArgumentError);
      expect(() => model.getPieceState(Coordinates(8, 5)), throwsArgumentError);
      expect(() => model.getPieceState(Coordinates(5, 8)), throwsArgumentError);
    });

    test('throws an error for a missing space', () {
      model.spaces.remove(Coordinates(0, 0));
      expect(() => model.getPieceState(Coordinates(0, 0)), throwsArgumentError);
    });
  });

  group('setPieceState', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('correctly updates the state of valid coordinates', () {
      Coordinates coords = Coordinates(0, 0);

      model.setPieceState(coords, PieceState.empty);
      expect(model.getPieceState(coords), equals(PieceState.empty));
    });

    test('throws an error for invalid coordinates', () {
      expect(() => model.setPieceState(Coordinates(-1, 5), PieceState.empty),
          throwsArgumentError);
      expect(() => model.setPieceState(Coordinates(5, -1), PieceState.empty),
          throwsArgumentError);
      expect(() => model.setPieceState(Coordinates(8, 5), PieceState.empty),
          throwsArgumentError);
      expect(() => model.setPieceState(Coordinates(5, 8), PieceState.empty),
          throwsArgumentError);
    });

    test('throws an error for a missing space', () {
      model.spaces.remove(Coordinates(0, 0));
      expect(() => model.setPieceState(Coordinates(0, 0), PieceState.empty),
          throwsArgumentError);
    });
  });

  group('hasValidMoves', () {
    late BoardModel model;

    setUp(() => model = BoardModel());

    test('returns false on a completely full board for both players', () {
      expect(model.hasValidMoves(PieceState.black), isFalse);
      expect(model.hasValidMoves(PieceState.white), isFalse);
    });

    test('returns false on a completely empty board for both players', () {
      setBoardState(
          model,
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.hasValidMoves(PieceState.black), isFalse);
      expect(model.hasValidMoves(PieceState.white), isFalse);
    });

    test('handles cases where only black has valid moves', () {
      setBoardState(
          model,
          'bw_-_-_-\n'
          'w-_-_-_-\n'
          '_-_w_-_w\n'
          '_-wbw-_b\n'
          '_-_w_-_w\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n'
          '_-wbw-_-\n');

      expect(model.hasValidMoves(PieceState.black), isTrue);
      expect(model.hasValidMoves(PieceState.white), isFalse);
    });

    test('handles cases where only white has valid moves', () {
      setBoardState(
          model,
          '_-_-_-bw\n'
          '_-_-_-_b\n'
          '_-b-_-_-\n'
          '_bwb_-_b\n'
          '_-b-_-_w\n'
          '_-_-_-_b\n'
          '_-_-_-_-\n'
          '_-_bwb_-\n');

      expect(model.hasValidMoves(PieceState.black), isFalse);
      expect(model.hasValidMoves(PieceState.white), isTrue);
    });

    test('handles cases where both players have valid moves', () {
      setBoardState(
          model,
          'bw_-_w_-\n'
          '_-_-_b_-\n'
          '_wb-_w_-\n'
          '_-wb_-_-\n'
          '_-_-_-_-\n'
          '_-_bwb_-\n'
          '_-_-_-_-\n'
          '_-_-_-_-\n');

      expect(model.hasValidMoves(PieceState.black), isTrue);
      expect(model.hasValidMoves(PieceState.white), isTrue);
    });
  });

  group('isValidCoordinate', () {
    late BoardModel model;
    setUp(() => model = BoardModel());

    test('accepts valid coordinates', () {
      expect(model.isValidCoordinate(Coordinates(0, 0)), isTrue);
      expect(model.isValidCoordinate(Coordinates(7, 7)), isTrue);
      expect(model.isValidCoordinate(Coordinates(3, 6)), isTrue);
    });

    test('rejects negative coordinates', () {
      expect(model.isValidCoordinate(Coordinates(-1, 0)), isFalse);
      expect(model.isValidCoordinate(Coordinates(0, -1)), isFalse);
      expect(model.isValidCoordinate(Coordinates(-1, -1)), isFalse);
    });

    test('rejects coordinates past the bounds of the board', () {
      expect(model.isValidCoordinate(Coordinates(8, 0)), isFalse);
      expect(model.isValidCoordinate(Coordinates(0, 8)), isFalse);
      expect(model.isValidCoordinate(Coordinates(8, 8)), isFalse);
    });
  });
}
