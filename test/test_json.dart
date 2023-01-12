import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
List<int> boardState = [1, 0, 0,
  0, 0, 0,
  0, 0, 0];
Future<String> fuck() {
  var jsonContent = rootBundle.loadString("Player_O_AI.json");
  return jsonContent;
}

void main() {
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += boardState[i] * pow(3, i) as int;
  }
  print(sum);
}