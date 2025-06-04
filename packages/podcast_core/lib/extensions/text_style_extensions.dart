import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle withOpacity([double opacity = 0.8]) {
    return copyWith(color: color?.withValues(alpha: opacity));
  }
}
