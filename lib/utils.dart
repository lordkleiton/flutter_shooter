double normalize(double value, double min, double max) {
  final double result = (value - min) / (max - min);

  if (result < 0.0) return 0.0;
  if (result > 1.0) return 1.0;

  return result;
}

double denormalize(double value, double min, double max) {
  final double result = (value - min) * (max - min);

  if (result < min) return min;
  if (result > max) return max;

  return result;
}
