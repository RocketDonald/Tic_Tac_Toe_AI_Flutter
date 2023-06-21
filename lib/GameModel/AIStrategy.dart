import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'Move.dart';

// TODO - Load the AI moves in main page?
class AIStrategy {
  final int X = 0;
  final int O = 1;

  late Map bestMovesX;
  late Map bestMovesO;

  AIStrategy() {
    /**
        rootBundle.loadString("assets/Player_X_AI.json").then((jsonContentX) =>
            parseJson(jsonContentX, X));
        rootBundle.loadString("assets/Player_O_AI.json").then((jsonContentO) =>
            parseJson(jsonContentO, O));
  */
    loadMoves(); // An async function that fetch all the moves
  }

  /// This function parse the string data of json into a map
  Map parseMoves(String data) {
    print("Now parsing moves");
    var decoded = jsonDecode(data);
    final p = Map.from(decoded);
    return p;
  }

  /// This function reads the json data and parse the data into a map
  Future<Map> fetchMoves(int player) async{
    String path;

    if (player == X) {
      path = "assets/Player_X_AI.json";
    } else {
      path = "assets/Player_O_AI.json";
    }

    return parseMoves(await rootBundle.loadString(path));
  }

  void loadMoves() async{
    print("Begin to load moves");
    await fetchMoves(X).then((val) {
      bestMovesX = val;
    });
    await fetchMoves(O).then((val) {
      bestMovesO = val;
    });
    print(bestMovesX);
    print(bestMovesO);
  }

  void parseJson(jsonContent, int player) {
    if (player == X) {
      bestMovesX = json.decode(jsonContent);
    } else {
      bestMovesO = json.decode(jsonContent);
    }
  }

  int getAIMoveX(int state) {
    return bestMovesX[state.toString()];
  }
  int getAIMoveO(int state) {
    return bestMovesO[state.toString()];
  }
}
