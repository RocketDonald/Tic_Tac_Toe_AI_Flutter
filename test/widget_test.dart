import 'package:tic_tac_toe/GameModel/AIStrategy.dart';
import 'package:tic_tac_toe/GameModel/Board.dart';
import 'package:tic_tac_toe/GameModel/Game.dart';
import 'package:tic_tac_toe/GameModel/Player.dart';

void main() {
  AIStrategy strategy = AIStrategy();
  Player aiX = AIPlayer("X", strategy);
  Player humanO = HumanPlayer("O");
  Board board = Board();
  Game game = Game(aiX, humanO, board);
  game.startGame();
}
