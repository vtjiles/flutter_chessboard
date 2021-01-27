import 'package:flutter_chessboard/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get square at rankIndex 0, fileIndex 0 with orientation w', () {
    expect(getSquare(0, 0, 'w'), 'a8');
  });
}
