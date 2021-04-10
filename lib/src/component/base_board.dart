import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/extensions.dart';
import 'package:flutter_shooter/src/component/canvas.dart';
import 'package:flutter_shooter/src/component/player.dart';

class BaseBoardComponent extends StatefulWidget {
  @override
  _BaseBoardComponentState createState() => _BaseBoardComponentState();
}

class _BaseBoardComponentState extends State<BaseBoardComponent> {
  Offset offset = Offset.zero;
  Offset normalOffset = Offset.zero;
  double angle = 90;
  bool toRight = false;

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes(context: context);
    final double middle = appSizes.midWidth;
    final Offset start = Offset(middle, appSizes.height);
    final double auxAngle = (90 - angle).degreeToRadian();

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        updateAngle(details, appSizes);
      },
      child: CustomPaint(
        painter: CanvasComponent(
          end: offset,
          start: start,
          display: normalOffset,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: appSizes.midWidth - 50,
              child: Column(
                children: [
                  PlayerComponent(angle: auxAngle),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                angle.toStringAsFixed(4) + 'º',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateAngle(DragUpdateDetails details, AppSizes appSizes) {
    final double middle = appSizes.midWidth;
    final Offset start = Offset(middle, appSizes.height);
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
    final double correctedAngle = positive ? angleDegrees : 180 - angleDegrees;

    setState(() {
      offset = position;
      normalOffset = Offset(adjacentLeg, oppositeLeg);
      angle = correctedAngle;
      toRight = positive;
    });
  }
}
