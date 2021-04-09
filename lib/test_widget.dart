import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/extensions.dart';

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
        final double adjacentLeg = x.normalize(0, middle);
        final double oppositeLeg = y.normalize(0, appSizes.height);
        final double hypotenuse =
            sqrt(adjacentLeg.squared() + oppositeLeg.squared());
        final double sin = oppositeLeg / hypotenuse;
        final double angleRadians = asin(sin);
        final double angleDegrees = angleRadians.radianToDegree();

        print(angleDegrees);

        setState(() {
          offset = position;
          normalOffset = Offset(adjacentLeg, oppositeLeg);
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

  void drawGrid(Canvas canvas, Size size,
      {int verticalLines = 4, int horizontalLines = 4}) {
    drawVerticalGrid(canvas, size, verticalLines);

    drawHorizontalGrid(canvas, size, horizontalLines);
  }

  void drawVerticalGrid(Canvas canvas, Size size, int qtyLines) {
    final double horizontal = size.width / qtyLines;

    for (int i = 1; i < qtyLines; i++) {
      drawLine(canvas, horizontal * i, 0, horizontal * i, size.height);
    }
  }

  void drawHorizontalGrid(Canvas canvas, Size size, int qtyLines) {
    final double vertical = size.height / qtyLines;

    for (int i = 1; i < qtyLines; i++) {
      drawLine(canvas, 0, vertical * i, size.width, vertical * i);
    }
  }
}
