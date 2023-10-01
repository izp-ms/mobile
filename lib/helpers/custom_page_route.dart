import 'package:flutter/material.dart';

Route customPageRoute(Widget child, AxisDirection direction) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      Offset end = Offset.zero;

      switch (direction) {
        case AxisDirection.up:
          begin = const Offset(0, 1);
          break;
        case AxisDirection.down:
          begin = const Offset(0, -1);
          break;
        case AxisDirection.right:
          begin = const Offset(-1, 0);
          break;
        case AxisDirection.left:
          begin = const Offset(1, 0);
          break;
        default:
          begin = const Offset(-1, 0);
      }

      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
