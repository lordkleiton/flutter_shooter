import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/utils.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes(context: context);
    final Offset start = Offset(appSizes.width / 2, appSizes.height);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final Offset position = details.globalPosition;
        final double x = normalize(position.dx, 0, appSizes.width);
        final double y = normalize(position.dy, 0, appSizes.height);

        setState(() {
          offset = position;
        });
      },
      child: CustomPaint(
        painter: AppCanvas(
          end: offset,
          start: start,
        ),
      ),
    );
  }
}

class AppCanvas extends CustomPainter {
  final Offset start;
  final Offset end;

  AppCanvas({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(start, end, Paint()..color = Colors.accents.first);

    final paragraph = ParagraphBuilder(
      ParagraphStyle(fontSize: 15),
    )..addText(
        '(x: ${end.dx.toStringAsFixed(2)}, y: ${end.dy.toStringAsFixed(2)})');

    final blabla = paragraph.build();

    blabla.layout(ParagraphConstraints(width: 300));

    canvas.drawParagraph(blabla, end);
  }

  @override
  bool shouldRepaint(covariant AppCanvas oldDelegate) =>
      oldDelegate.end.dx != end.dx || oldDelegate.end.dy != end.dy;
}
