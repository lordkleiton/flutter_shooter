import 'package:flutter/material.dart';
import 'package:flutter_shooter/routes.dart';
import 'package:flutter_shooter/test_widget.dart';

abstract class AppRouter {
  static Route<dynamic> routeGenerator(RouteSettings settings) {
    final Map<String, dynamic>? args =
        settings.arguments as Map<String, dynamic>?;

    print(args);

    switch (settings.name) {
      case AppRoutes.home:
        return _builder(TestWidget());
      default:
        return _builder(_err());
    }
  }

  static Widget _err() => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('🤔'),
        ),
      );

  static MaterialPageRoute _builder(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);
}
