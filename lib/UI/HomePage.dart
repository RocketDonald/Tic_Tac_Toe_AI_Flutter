import 'dart:convert';

import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/androidstudio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/Utils/FileToWidget.dart';

class HomePage extends StatelessWidget implements AppPages{
  HomePage({Key? key, required this.widthBreakPoint, required this.goToNextPage}) : super(key: key);

  late Function goToNextPage;
  late int widthBreakPoint;

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        if (constrains.maxWidth > widthBreakPoint) {
          return _wide();
        } else {
          return _normal();
        }
      },
    );
  }

  Widget _wide() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Block_1(widthBreakPoint: widthBreakPoint, goToNextPage: goToNextPage,),
          Block_2(sizeBreakingPoint: widthBreakPoint,),
        ],
      ),
    );
  }

  Widget _normal() {
    return PageView(
      controller: controller,
      children: [
        Block_1(widthBreakPoint: widthBreakPoint, goToNextPage: goToNextPage,),
        Block_2(sizeBreakingPoint: widthBreakPoint,),
      ],
    );
  }
}

class Block_1 extends StatelessWidget {
  Block_1({Key? key, required this.widthBreakPoint, required this.goToNextPage}) : super(key: key);
  final double _width =  WidgetsBinding.instance.window.physicalSize.width;
  late int widthBreakPoint;
  late Function goToNextPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > widthBreakPoint) {
            return _createWideWidget();
          } else {
            return _createNormalWidget();
          }
        }
    );
  }

  Widget _createWideWidget() {
    return Container(
      color: Colors.blueGrey,
      child: SizedBox(
        height: 400,
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset("images/Home_Page_Background.jpg"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _width * 0.06, top: 220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
                    child: Text("AI designed for Tic Tac Toe", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 32),),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 12),
                    child: Text("This AI is a reinforcement-learning-based AI. Unbeatable, Fast, Tricky.", style: TextStyle(color: Colors.white, fontSize: 14),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TextButton(
                        onPressed: () {
                          goToNextPage(1);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Play", style: TextStyle(color: Colors.white),),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createNormalWidget() {
    return Container(
      child: SizedBox(
        height: 600,
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset("images/Home_Page_Background.jpg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:300, bottom: 300),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
                      child: Text("AI designed for Tic Tac Toe", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 32),),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 12),
                      child: Text("This AI is a reinforcement-learning-based AI. Unbeatable, Fast, Tricky.", style: TextStyle(color: Colors.white, fontSize: 14),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                          onPressed: () {
                            goToNextPage(1);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Play", style: TextStyle(color: Colors.white),),
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_forward_rounded, color: Colors.greenAccent, size: 30,),
                          Text("Swipe Right To View More", style: TextStyle(color: Colors.greenAccent, fontSize: 18),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Block_2 extends StatelessWidget {
  Block_2({Key? key, required this.sizeBreakingPoint}) : super(key: key);
  int sizeBreakingPoint;
  String textFilePath = "texts/homePageBlock2.txt";
  String bestMoveTxtFilePath = "texts/homePageBlock2_BestMove.txt";
  var codeBlockTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300
  );
  List<Widget> widgetList = [];

  var codeTheme = androidstudioTheme;

  var code = ''' def train_against_strategy(self, opponent):
    self.total_iterations_trained += 1
    board = Board()
    learner = self.learner

    if learner.side == "X":
      player_X = learner
      player_O = opponent
    else:
      player_X = opponent
      player_O = learner''';

  var code2 = '''  def update_table(self, state_prev, state_after, action, reward):
    #print(self.Q_Table)
    # If Q[s,a] doesn't exist, create a new entry in Q_Table and K_Table, see more in add_new_entry(self, state)
    if not self.Q_Table.__contains__(state_prev):
      self.add_new_entry(state_prev)
    #print(self.Q_Table)
    # If Q[s',a'] doesn't exist, create a new entry in Q_Table and K_Table, such entry in Q_Table only has
    # the action -1 to indicate it has no control over its opponent's turn.
    if not self.Q_Table.__contains__(state_after):
      self.Q_Table[state_after] = {-1:0}
    #print(self.Q_Table)
    # The future reward is 0 if s' has no possible actions
    if self.Q_Table[state_after] == {}:
      future_reward = 0
    else:
      future_reward = self.Q_Table[state_after][-1]
    #print(self.Q_Table)
    Q_prev = self.Q_Table[state_prev][action]
    learning_rate = 1 / self.K_Table[state_prev][action]

    # Update the Q_Table using the formula: Q[s,a] = Q[s,a] + α_k(r + γ * max{Q[s',a']}- Q[s,a])
    Q_new = Q_prev + learning_rate * (reward + self.discount_factor * future_reward - Q_prev)
    #Q_new = Q_prev + 0.1 * (reward + self.discount_factor * future_reward - Q_prev)
    self.Q_Table[state_prev][action] = Q_new

    # Update K_Table
    self.K_Table[state_prev][action] += 1
    return''';

  var bestMoveTxt = '''Each time we run the training, the program will keep updating the Q-Table and K-Table, which keep track of the maximum expected future rewards. The higher the reward value, the better the move will be.''';

  Widget _createWideBlock() {
    return Container(
      color: Colors.brown,
      child: SizedBox(
        height: 1500,
        child: SizedBox.expand(
            child: Column(
              children: [
                FileToWidget(filePath: textFilePath).getFutureBuilder(),
                HighlightView(
                  code,
                  language: 'python',
                  theme: codeTheme,
                  padding: EdgeInsets.all(5),
                  textStyle: codeBlockTextStyle,
                ),
                FileToWidget(filePath: bestMoveTxtFilePath).getFutureBuilder(),
                HighlightView(
                  code2,
                  language: 'python',
                  theme: codeTheme,
                  padding: EdgeInsets.all(5),
                  textStyle: codeBlockTextStyle,
                ),
              ],
            )),
      )
    );
  }

  Widget _createNormalBlock() {
    return Container(
      color: Colors.brown,
      child: Column(
        children: [
          FileToWidget(filePath: textFilePath).getFutureBuilder(),
          HighlightView(
            code,
            language: 'python',
            theme: codeTheme,
            padding: EdgeInsets.all(5),
            textStyle: codeBlockTextStyle,
          ),
          FileToWidget(filePath: bestMoveTxtFilePath).getFutureBuilder(),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determines the width of the screen
          // If the size is larger then the breaking point, then web page format will be used, else phone format
          if (constraints.maxWidth > sizeBreakingPoint) {
            return _createWideBlock();
          } else {
            return _createNormalBlock();
          }
        },
    );
  }
}


