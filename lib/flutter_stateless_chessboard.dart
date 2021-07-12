library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';

export 'package:flutter_stateless_chessboard/types.dart';

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  final String fen;

  final types.Color orientation;
  final void Function(types.ShortMove move)? onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;
  final bool showLabels;

  Chessboard({
    required this.fen,
    this.orientation = types.Color.WHITE,
    this.onMove,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    this.showLabels = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChessboardState();
  }
}

class _ChessboardState extends State<Chessboard> {
  types.HalfMove? _clickMove;

  @override
  Widget build(BuildContext context) {
    final pieceMap = getPieceMap(widget.fen);

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(builder: (context, constraints) {
        final squareSize = constraints.maxWidth / 8;

        return Row(
          children: zeroToSeven.map((fileIndex) {
            return Expanded(
                child: Column(
              children: zeroToSeven.map((rankIndex) {
                final square =
                    getSquare(rankIndex, fileIndex, widget.orientation);
                final color = (rankIndex + fileIndex) % 2 == 0
                    ? widget.lightSquareColor
                    : widget.darkSquareColor;
                var child = ChessSquare(
                  name: square,
                  color: color,
                  size: squareSize,
                  highlight: _clickMove?.square == square,
                  piece: pieceMap[square],
                  onDrop: (move) {
                    if (widget.onMove != null) {
                      widget.onMove!(move);
                      setClickMove(null);
                    }
                  },
                  onClick: (halfMove) {
                    if (_clickMove != null) {
                      if (_clickMove!.square == halfMove.square) {
                        setClickMove(null);
                      } else if (_clickMove!.piece?.color ==
                          halfMove.piece?.color) {
                        setClickMove(halfMove);
                      } else if (widget.onMove != null) {
                        widget.onMove!(types.ShortMove(
                          from: _clickMove!.square,
                          to: halfMove.square,
                          promotion: types.PieceType.QUEEN,
                        ));
                      }
                      setClickMove(null);
                    } else if (halfMove.piece != null) {
                      setClickMove(halfMove);
                    }
                  },
                );

                if (widget.showLabels) {
                  var children = <Widget>[child];
                  var labelColor = [
                    widget.lightSquareColor,
                    widget.darkSquareColor
                  ].firstWhere((it) => it != color);

                  var labelStyle = TextStyle(
                    color: labelColor,
                  );

                  Widget _label(String label) {
                    return Text(label, style: labelStyle);
                  }

                  if (fileIndex == 0) {
                    var label = widget.orientation == types.Color.WHITE
                        ? 8 - rankIndex
                        : rankIndex + 1;

                    children.add(Positioned(
                      top: 1,
                      left: 1,
                      child: _label('$label'),
                    ));
                  }

                  if (rankIndex == 7) {
                    var letters = 'abcdefgh'.split('');
                    var label = widget.orientation == types.Color.WHITE
                        ? letters[fileIndex]
                        : letters.reversed.toList()[fileIndex];

                    children.add(
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: _label(label),
                      ),
                    );
                  }

                  if (children.length > 1) {
                    return Stack(
                      children: children,
                    );
                  }
                }

                return child;
              }).toList(),
            ));
          }).toList(),
        );
      }),
    );
  }

  void setClickMove(types.HalfMove? move) {
    setState(() {
      _clickMove = move;
    });
  }
}
