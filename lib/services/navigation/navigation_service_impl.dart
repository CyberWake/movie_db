import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_db/services/navigation/navigation_service.dart';

class AppNavigationServiceImpl extends NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? getCurrentRoute() {
    return ModalRoute.of(navigatorKey.currentState!.context)?.settings.name;
  }

  @override
  Future<dynamic> pushScreen(
    String routeName, {
    dynamic arguments,
    bool makeHapticFeedback = false,
  }) {
    if (makeHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  void pushScreensAndReplaceFirst(
    List<String> routeNames, {
    required List<dynamic> arguments,
  }) {
    for (int i = 0; i < routeNames.length; i++) {
      if (i == 0) {
        pushReplacementScreen(routeNames[i], arguments: arguments[i]);
      }
      pushScreen(routeNames[i], arguments: arguments[i]);
    }
  }

  @override
  Future<dynamic> popAndPushScreen(String routeName, {dynamic arguments}) {
    navigatorKey.currentState!.pop();
    return pushScreen(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> pushReplacementScreen(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> popAndPushReplacement(String routeName, {dynamic arguments}) {
    navigatorKey.currentState!.pop();
    return pushReplacementScreen(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> removeAllAndPush(
    String routeName,
    String tillRoute, {
    dynamic arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(tillRoute),
      arguments: arguments,
    );
  }

  @override
  Future<dynamic> pushDialog(Widget dialog, {bool isDismissible = false}) {
    return Platform.isAndroid
        ? showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: isDismissible,
            builder: (BuildContext context) {
              return dialog;
            },
          )
        : showCupertinoDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: isDismissible,
            builder: (BuildContext context) {
              return dialog;
            },
          );
  }

  @override
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: duration,
          content: Text(message),
        ),
      );

  @override
  Future<void> pop({dynamic sendDataBack, bool changeColor = true}) async {
    HapticFeedback.selectionClick();
    return navigatorKey.currentState!.pop(sendDataBack);
  }

}
