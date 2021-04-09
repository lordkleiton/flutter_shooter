import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_shooter/extensions.dart';

class CanvasComponent extends CustomPainter {
  final Offset start;
  final Offset end;
  final Offset display;

  CanvasComponent(
      {required this.start, required this.end, required this.display});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawGrid(size);

    canvas.drawLine(start, end, Paint()..color = Colors.accents.first);

    drawCoordinates(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CanvasComponent oldDelegate) =>
      oldDelegate.end.dx != end.dx || oldDelegate.end.dy != end.dy;

  void drawCoordinates(Canvas canvas, Size size) {
    final double width = 140;
    final String text =
        '(x: ${display.dx.toStringAsFixed(4)}, y: ${display.dy.toStringAsFixed(4)})';
    final ParagraphBuilder builder =
        ParagraphBuilder(ParagraphStyle(fontSize: 15));

    builder.addText(text);

    final Paragraph paragraph = builder.build();

    paragraph.layout(ParagraphConstraints(width: width));

    canvas.drawParagraph(
        paragraph, Offset((size.width / 2) - (width / 2), size.height / 2));
  }
}
