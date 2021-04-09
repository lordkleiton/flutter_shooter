import 'package:flutter/material.dart';
import 'package:flutter_shooter/app_sizes.dart';
import 'package:flutter_shooter/src/component/test_widget.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes(context: context);

    return Scaffold(
      body: Container(
        color: Colors.black,
        width: appSizes.width,
        height: appSizes.height,
        child: TestWidget(),
      ),
    );
  }
}
