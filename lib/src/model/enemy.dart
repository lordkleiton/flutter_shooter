import 'package:flutter/rendering.dart';

class Enemy {
  final double angle;
  final Offset target;
  Offset position;

  Enemy({required this.position, required this.angle, required this.target});
}
