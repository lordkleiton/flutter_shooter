import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

extension DoubleUtils on double {
  double radianToDegree() => this * (180 / math.pi);
}

extension NumberUtils on num {
  double normalize(double min, double max) {
    final double result = (this - min) / (max - min);

    if (result < 0.0) return 0.0;
    if (result > 1.0) return 1.0;

    return result;
  }

  double denormalize(double min, double max) {
    final double result = (this - min) * (max - min);

    if (result < min) return min;
    if (result > max) return max;

    return result;
  }

  double getPercentage(double percentage) => this * (percentage / 100);

  num squared() => this * this;

  num sqrt() => math.sqrt(this);
}

extension CanvasUtils on Canvas {
  void _customDrawLine(double xStart, double yStart, double xEnd, double yEnd) {
    this.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd),
        Paint()..color = Colors.accents.first);
  }

  void drawGrid(Size size, {int verticalLines = 4, int horizontalLines = 4}) {
    drawVerticalGrid(size, verticalLines);

    drawHorizontalGrid(size, horizontalLines);
  }

  void drawVerticalGrid(Size size, int qtyLines) {
    final double horizontal = size.width / qtyLines;

    for (int i = 1; i < qtyLines; i++) {
      _customDrawLine(horizontal * i, 0, horizontal * i, size.height);
    }
  }

  void drawHorizontalGrid(Size size, int qtyLines) {
    final double vertical = size.height / qtyLines;

    for (int i = 1; i < qtyLines; i++) {
      _customDrawLine(0, vertical * i, size.width, vertical * i);
    }
  }
}
