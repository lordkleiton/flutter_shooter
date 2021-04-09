import 'package:flutter/widgets.dart';
import 'utils.dart';

class AppSizes {
  final BuildContext context;

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;
  double get midWidth => width / 2;
  double get midHeight => height / 2;

  AppSizes({required this.context});

  double responsiveWidth(double percentage) => getPercentage(width, percentage);

  double responsiveHeight(double percentage) =>
      getPercentage(height, percentage);
}
