import 'package:flutter/material.dart';

class CellModel {
  int no = 0;
  CellState state = CellState.closeState;

// CellModel(this.no, this.state);
}

enum CellState {
  openState,
  closeState,
  flagState,
}

enum GameState {
  general,
  win,
  blast,

}

extension RestartColor  on GameState {
  Color get restartColor {
      return  {GameState.win:Colors.green,GameState.blast:Colors.red}[this]?? Colors.blue;
  }
}

