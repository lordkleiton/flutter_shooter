import 'package:flutter/widgets.dart';

class AppSizes {
  final BuildContext context;
  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;

  AppSizes({required this.context});
}
