import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/UI/GameBoard.dart';
import 'package:tic_tac_toe/Utils/GameManager.dart';

class PlayPage extends StatefulWidget implements AppPages{
  int widthBreakPoint;

  PlayPage({Key? key, required this.widthBreakPoint}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // Global Key for a game board
  final GlobalKey<GameBoardState> gameBoardKey = GlobalKey<GameBoardState>();

  // List for player sides
  Icon iconX = const Icon(Icons.close, color: Colors.lightBlueAccent,);
  Icon iconO = const Icon(Icons.circle_outlined, color: Colors.amberAccent);
  late List<Icon> playerSide;
  late Icon selectedPlayerSide;

  // List for difficulties
  List<String> difficulties = ["Beginner", "Intermediate", "Expert"];
  String seletedDifficulties = "Beginner";

  // Game Manager for the board
  late GameManager manager;

  // String for displaying the score
  late String _scoreText;
  String _restartingText = "";

    @override
    void initState() {
      playerSide = [iconX, iconO];
      selectedPlayerSide = iconX;
      manager = GameManager(1);
      _setScoreText();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
          if (constrains.maxWidth > widget.widthBreakPoint) {
            return _widePage(constrains.maxWidth, constrains.maxHeight);
          } else {
            return _normalPage(constrains.maxWidth, constrains.maxHeight);
          }
        },
      );
    }

  Widget _widePage(double width, double height) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 2.0, color: Colors.black12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _createPlayerSideRadioButton(false),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                  child: _createDifficultiesDropdownList(false),
                ),
              ],
            ),
          ),
        ),
      ),
      Flexible(
          flex: 3 ,
          child: Center(
             child: _createGameBoard(width, height),
          )
      ),
    ],
      );
  }

  Widget _normalPage(double width, double height) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.black12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(flex: 1, child: _createPlayerSideRadioButton(true)),
                Flexible(flex: 1, child: _createDifficultiesDropdownList(true)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: _createGameBoard(width, height),
        ),
      ]
    );
  }

  void _setScoreText() {
    late String text;
    if (manager.humanPlayerSide == 1) {
      text = "You  ${manager.playerOneScore} : ${manager.playerTwoScore}  $seletedDifficulties AI";
    } else if (manager.humanPlayerSide == 2) {
      text = "$seletedDifficulties AI  ${manager.playerOneScore} : ${manager.playerTwoScore}  You";
    } else {
      // AI vs AI
      text = "${manager.playerOneScore} : ${manager.playerTwoScore}";
    }
    text += "\n${manager.tie} Ties";
      setState(() {
        _scoreText = text;
      });
  }

  void _setWinningText() {
    setState(() {
      if (_restartingText == "") {
        _restartingText = "A new game will start in 2 seconds";
      } else {
        _restartingText = "";
      }
    });
  }

  /// This is a call back function that will be passed into the GameBoard
  /// When a game finished, this function will be called to change the scoreText and winningText in this class state
  void endGameCallBack() {
    setState(() {
      _setScoreText();
      _setWinningText();
    });
  }

  Widget _createGameBoard(double width, double height) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_scoreText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: GameBoard(
              size: min(width *0.6, height * 0.6),
              manager: manager,
              gameMode: GameBoard.PVE,
              key: gameBoardKey,
              endGameCallBack: endGameCallBack,),
          ),
          Text(_restartingText, textAlign: TextAlign.center,),
        ],
      );
  }

  Widget _createDifficultiesDropdownList(bool normal) {
      if (!normal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Difficulties", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            DropdownButton(
                value: seletedDifficulties,
                iconEnabledColor: Colors.greenAccent,
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.greenAccent,
                ),
                items: difficulties.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value){
                  if (value != null) {
                    setState(() {
                      seletedDifficulties = value;
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      manager.resetScores();
                      _setScoreText();
                    });
                  }
                }),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Difficulties", textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
            DropdownButton(
                value: seletedDifficulties,
                iconEnabledColor: Colors.greenAccent,
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.greenAccent,
                ),
                items: difficulties.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value){
                  if (value != null) {
                    setState(() {
                      seletedDifficulties = value;
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      manager.resetScores();
                      _setScoreText();
                    });
                  }
                }),
          ],
        );
      }

  }

  // Create a set of radio buttons that indicate the gamemode (PVE/EVE)
  Widget _createPlayerSideRadioButton(bool normal) {
      if(!normal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18, top: 10, bottom: 8),
              child: Text("Pick a side", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              title: Align(alignment: Alignment.centerLeft, child: playerSide[0]),
              leading: Radio<Icon>(
                value: playerSide[0],
                groupValue: selectedPlayerSide,
                onChanged: (Icon? value) {
                  setState(() {
                    if (value != null) {
                      selectedPlayerSide = value;
                      manager.humanPlayerSwitchSide();
                      _setScoreText();
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      gameBoardKey.currentState!.setHumanPlayerSide(1);
                    }
                  });
                },
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: 0),
              title: Align(alignment: Alignment.centerLeft, child: playerSide[1]),
              leading: Radio<Icon>(
                value: playerSide[1],
                groupValue: selectedPlayerSide,
                onChanged: (Icon? value) {
                  setState(() {
                    if (value != null) {
                      selectedPlayerSide = value;
                      manager.humanPlayerSwitchSide();
                      _setScoreText();
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      gameBoardKey.currentState!.setHumanPlayerSide(2);
                      gameBoardKey.currentState!.aiMakesFirstMove();
                    }
                  });
                },
              ),
            ),
          ],
        );
      } else {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 18),
             child: Text("Pick a side", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
           ),
           Row(
             children: [
               Flexible(
                 child: ListTile(
                   visualDensity: VisualDensity(vertical: -4),
                   title: Align(alignment: Alignment.centerLeft, child: playerSide[0]),
                   leading: Radio<Icon>(
                     value: playerSide[0],
                     groupValue: selectedPlayerSide,
                     onChanged: (Icon? value) {
                       setState(() {
                         if (value != null) {
                           selectedPlayerSide = value;
                           manager.humanPlayerSwitchSide();
                           _setScoreText();
                           // Reset the score and the board
                           gameBoardKey.currentState!.endGameProtocol(0);
                           gameBoardKey.currentState!.setHumanPlayerSide(1);
                         }
                       });
                     },
                   ),
                 ),
               ),
               Flexible(
                 child: ListTile(
                   visualDensity: VisualDensity(vertical: 0),
                   title: Align(alignment: Alignment.centerLeft, child: playerSide[1]),
                   leading: Radio<Icon>(
                     value: playerSide[1],
                     groupValue: selectedPlayerSide,
                     onChanged: (Icon? value) {
                       setState(() {
                         if (value != null) {
                           selectedPlayerSide = value;
                           manager.humanPlayerSwitchSide();
                           _setScoreText();
                           // Reset the score and the board
                           gameBoardKey.currentState!.endGameProtocol(0);
                           gameBoardKey.currentState!.setHumanPlayerSide(2);
                           gameBoardKey.currentState!.aiMakesFirstMove();
                         }
                       });
                     },
                   ),
                 ),
               ),
             ],
           ),
         ],
       );
      }
  }


}

