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
        final double y = start.dy - position.dy;
        final double normalizedX = normalize(x, 0, middle);
        final double normalizedY = normalize(y, 0, appSizes.height);
        /* final double squareX = x * x;
        final double squareY = y * y;
        final double line =
            sqrt(normalizedX * normalizedX) + (normalizedY * normalizedY);
        final double line2 = normalize(line, 0, 2);
        final double sin = normalizedX >= 0.1
            ? double.parse(normalizedY.toStringAsPrecision(2)) /
                double.parse(line2.toStringAsPrecision(2))
            : 1;

        print(sin); */

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
    drawGrid(canvas, size);

    //linha do ponteiro
    canvas.drawLine(start, end, Paint()..color = Colors.accents.first);

    final paragraph = ParagraphBuilder(
      ParagraphStyle(fontSize: 15),
    )..addText(
        '(x: ${display.dx.toStringAsFixed(4)}, y: ${display.dy.toStringAsFixed(4)})');

    final blabla = paragraph.build();

    final double paragraphWidth = 140;

    blabla.layout(ParagraphConstraints(width: paragraphWidth));

    canvas.drawParagraph(blabla,
        Offset((size.width / 2) - (paragraphWidth / 2), size.height / 2));
  }

  @override
  bool shouldRepaint(covariant AppCanvas oldDelegate) =>
      oldDelegate.end.dx != end.dx || oldDelegate.end.dy != end.dy;

  void drawLine(
      Canvas canvas, double xStart, double yStart, double xEnd, double yEnd) {
    canvas.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd),
        Paint()..color = Colors.accents.first);
  }

  void drawGrid(Canvas canvas, Size size) {
    drawVerticalGrid(canvas, size);

    drawHorizontalGrid(canvas, size);
  }

  void drawVerticalGrid(Canvas canvas, Size size) {
    final double horizontal = size.width / 4;

    drawLine(canvas, horizontal, 0, horizontal, size.height);
    drawLine(canvas, horizontal * 2, 0, horizontal * 2, size.height);
    drawLine(canvas, horizontal * 3, 0, horizontal * 3, size.height);
  }

  void drawHorizontalGrid(Canvas canvas, Size size) {
    final double vertical = size.height / 4;

    drawLine(canvas, 0, vertical, size.width, vertical);
    drawLine(canvas, 0, vertical * 2, size.width, vertical * 2);
    drawLine(canvas, 0, vertical * 3, size.width, vertical * 3);
  }
}
