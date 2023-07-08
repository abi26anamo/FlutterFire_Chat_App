import 'package:flutter/material.dart';

class RoutingService {
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _routeName) {
    navigatorKey.currentState!.popAndPushNamed(_routeName);
  }

  void navigateToRoute(String _routeName) {
    navigatorKey.currentState!.pushNamed(_routeName);
  }

  void navigateToPage(Widget _page) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
