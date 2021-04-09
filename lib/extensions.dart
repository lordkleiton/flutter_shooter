import 'dart:math' as math;

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
