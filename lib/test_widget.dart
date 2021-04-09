import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/utils.dart';

import 'utils.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Offset offset = Offset.zero;
  Offset normalOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes(context: context);
    final double middle = appSizes.midWidth;
    final Offset start = Offset(middle, appSizes.height);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final Offset position = details.globalPosition;
        final bool positive = position.dx >= middle;
        final double x = positive ? position.dx - middle : middle - position.dx;
        final double normalizedX = normalize(x, 0, middle);
        final double normalizedY = normalize(position.dy, 0, appSizes.height);

        final double line =
            sqrt(normalizedX * normalizedX) + (normalizedY * normalizedY);

        print('$normalizedX, $normalizedY, $line');

        setState(() {
          offset = position;
          normalOffset = Offset(normalizedX, normalizedY);
        });
      },
      child: CustomPaint(
        painter: AppCanvas(
          end: offset,
          start: start,
          display: normalOffset,
        ),
      ),
    );
  }
}

class AppCanvas extends CustomPainter {
  final Offset start;
  final Offset end;
  final Offset display;

  AppCanvas({required this.start, required this.end, required this.display});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(start, end, Paint()..color = Colors.accents.first);

    final paragraph = ParagraphBuilder(
      ParagraphStyle(fontSize: 15),
    )..addText(
        '(x: ${display.dx.toStringAsFixed(2)}, y: ${display.dy.toStringAsFixed(2)})');

    final blabla = paragraph.build();

    final double paragraphWidth = 110;

    blabla.layout(ParagraphConstraints(width: paragraphWidth));

    canvas.drawParagraph(blabla,
        Offset((size.width / 2) - (paragraphWidth / 2), size.height / 2));
  }

  @override
  bool shouldRepaint(covariant AppCanvas oldDelegate) =>
      oldDelegate.end.dx != end.dx || oldDelegate.end.dy != end.dy;
}
