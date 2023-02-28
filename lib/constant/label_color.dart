// Colorの値をStringに変換
import 'package:flutter/material.dart';

class LabelColor {
  static const List<String> labelcolor = [
    'red',
    'orange',
    'yellow',
    'lime',
    'green',
    'turquoise',
    'blue',
    'violet',
    'purple',
    'magenta',
  ];
}

Color stringifiedColorToColor(String stringifiedColor) {
  late Color reconvertedColor;

  switch (stringifiedColor) {
    case 'red':
      reconvertedColor = const Color(0xFFFF0000);
      break;
    case 'orange':
      reconvertedColor = const Color(0xFFFFA500);
      break;
    case 'yellow':
      reconvertedColor = const Color(0xFFffd700);
      break;
    case 'lime':
      reconvertedColor = const Color(0xFFADFF2F);
      break;
    case 'green':
      reconvertedColor = const Color(0xFF008000);
      break;
    case 'turquoise':
      reconvertedColor = const Color(0xFF009094);
      break;
    case 'blue':
      reconvertedColor = const Color(0xFF0000FF);
      break;
    case 'violet':
      reconvertedColor = const Color(0xFF5A4498);
      break;
    case 'purple':
      reconvertedColor = const Color(0xFF800080);
      break;
    case 'magenta':
      reconvertedColor = const Color(0xFFFF00FF);
      break;
  }

  return reconvertedColor;
}
