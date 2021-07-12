import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Color color;
  final Widget? child;
  final bool highlight;

  Square({
    required this.color,
    this.child,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Container(
            color: color,
          ),
          if (highlight == true)
            Container(
              color: Color.fromRGBO(128, 128, 128, .3),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
