import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppRouter {
  static back(BuildContext context) {
    return Navigator.pop(
      context,
    );
  }

  static push(BuildContext context, Widget page, String routeName) {
    return Navigator.push(
      context,
      FadeInRoute(page: page, routeName: routeName),
    );
  }

  static pushAndRemoveUntil(
      BuildContext context, Widget page, String routeName) {
    return Navigator.pushAndRemoveUntil(
      context,
      FadeInRoute(page: page, routeName: routeName),
      (route) => false,
    );
  }
}

class FadeInRoute extends PageRouteBuilder {
  final Widget page;

  FadeInRoute({required this.page, required String routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        );
}
