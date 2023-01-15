import 'dart:convert';

import 'package:flutter/services.dart';

class AIStrategy {
  late var bestMovesX;
  late var bestMovesO;

  AIStrategy() {
    bestMovesX =
        rootBundle.loadString("Player_X_AI.json").then((jsonContentX) =>
            parseJson(jsonContentX));
    bestMovesO =
        rootBundle.loadString("Player_O_AI.json").then((jsonContentO) =>
            parseJson(jsonContentO));
  }
  void parseJson(jsonContent) {
    bestMovesO = json.decode(jsonContent);
  }

  int getAIMoveX(int state) {
    return bestMovesX[state];
  }
  int getAIMoveO(int state) {
    return bestMovesO[state];
  }
}
