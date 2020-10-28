import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RandomColorUtil{
  List<Color> colors = <Color>[];
  Color getRandomColor(int index) {
    if (index >= colors.length) {
      colors.add(Color.fromARGB(255, Random.secure().nextInt(255),
          Random.secure().nextInt(255), Random.secure().nextInt(255)));
    }
    return colors[index];
  }
}