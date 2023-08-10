import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static pushAndPop(String routeName) {
    return navigatorKey.currentState!.popAndPushNamed(routeName);
  }

  static pop() {
    return navigatorKey.currentState!.pop();
  }
}
