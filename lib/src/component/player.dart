import 'package:flutter/material.dart';

class PlayerComponent extends StatelessWidget {
  final double angle;

  PlayerComponent({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 100,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}
