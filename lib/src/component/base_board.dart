import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/extensions.dart';
import 'package:flutter_shooter/src/component/canvas.dart';
import 'package:flutter_shooter/src/component/player.dart';
import 'package:flutter_shooter/src/model/enemy.dart';

class BaseBoardComponent extends StatefulWidget {
  final AppSizes appSizes;

  BaseBoardComponent({required this.appSizes});

  @override
  _BaseBoardComponentState createState() => _BaseBoardComponentState();
}

class _BaseBoardComponentState extends State<BaseBoardComponent> {
  late AppSizes appSizes;
  late Offset playerPosition;
  late List<Enemy> enemies;
  Offset offset = Offset.zero;
  Offset normalOffset = Offset.zero;
  double angle = 90;
  bool toRight = false;

  @override
  void initState() {
    super.initState();

    appSizes = widget.appSizes;

    playerPosition = Offset(appSizes.midWidth - 50, 0);

    final random = math.Random();

    final Function getRandomX =
        () => random.nextDouble().denormalize(0, appSizes.width);
    final Function getRandomY =
        () => random.nextDouble().denormalize(0, appSizes.midHeight);

    enemies = [
      Enemy(position: Offset.zero, angle: 0, target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
      Enemy(
          position: Offset(getRandomX(), getRandomY()),
          angle: 0,
          target: playerPosition),
    ];

    Timer.periodic(Duration(milliseconds: 16), (_) {
      bool update = false;

      enemies.forEach((enemy) {
        final Offset position = enemy.position;

        if ((position.dx < appSizes.width + 20 &&
                position.dy < appSizes.height) &&
            (position.dx > 0 && position.dy < appSizes.height)) {
          update = true;

          final Offset target = enemy.target;

          final double dx = position.dx - (target.dx + 50);
          final double dy =
              position.dy - (target.dy + appSizes.height + appSizes.height / 3);

          enemy.position =
              Offset(position.dx - (dx * 0.01), position.dy - (dy * 0.01));
        }
      });

      if (update) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ...enemies.map((element) {
              return Positioned(
                top: element.position.dy,
                left: element.position.dx,
                child: Container(
                  width: 10,
                  height: 10,
                  color: Colors.amber,
                ),
              );
            }).toList(),
            Positioned(
              bottom: playerPosition.dy,
              left: playerPosition.dx,
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
        math.sqrt(adjacentLeg.squared() + oppositeLeg.squared());
    final double sin = oppositeLeg / hypotenuse;
    final double angleRadians = math.asin(sin);
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
