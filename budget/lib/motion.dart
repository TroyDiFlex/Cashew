import 'package:flutter/material.dart';

/// Shared timings, independent from the app's colors and shapes.
abstract final class AppMotion {
  static const press = Duration(milliseconds: 100);
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 220);
  static const chart = Duration(milliseconds: 280);
  static const number = Duration(milliseconds: 360);

  static Duration resolve(BuildContext context, Duration duration,
      {bool enabled = true}) {
    return enabled && !(MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? duration
        : Duration.zero;
  }
}
