import 'package:flutter/widgets.dart';
import 'package:flutter_shooter/extensions.dart';

class AppSizes {
  final BuildContext context;

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;
  double get midWidth => width / 2;
  double get midHeight => height / 2;

  AppSizes({required this.context});

  double responsiveWidth(double percentage) => width.getPercentage(percentage);

  double responsiveHeight(double percentage) =>
      height.getPercentage(percentage);
}
