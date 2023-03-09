import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mine_swippers/screen/CellModel.dart';
import 'package:mine_swippers/screen/home_screen.dart';

extension abc on HomeScreenState {
  void setUp() {
    data.clear();
    noOfBomb = 0;
    gameState = GameState.general;
    data = List.generate(
        h,
        (index) => List.generate(
              w,
              (index) => CellModel(),
            ));

    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        int no = Random().nextInt(100);
        if (no < 60) {
          noOfBomb++;
          data[i][j].no = 9;
        }
      }
    }

    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        if (data[i][j].no == 9) {
          for (int x = i - 1; x <= i + 1; x++) {
            for (int y = j - 1; y <= j + 1; y++) {
              if (isProper(x, y)) {
                data[x][y].no = min(9, data[x][y].no + 1);
              }
            }
          }
        }
      }
    }

    print("${data.map((e) => e.map((e) => e.no))}");
    initalOpenLand();
    setState(() {});
  }

  void initalOpenLand() {
    int z = Random().nextInt(h*w);

    while (data[z ~/ w][z % w].no != 0) {
      z = Random().nextInt(h*w);
    }
    openLand(z ~/ w, z % w);
  }

  void openLand(int x, int y) {
    if (data[x][y].state == CellState.flagState) {
      return;
    }
    if (data[x][y].no == 0) {
      openLandAround(x, y);
    } else if (data[x][y].no == 9) {
      gameOver();
    } else {
      // print("OpenLandCall");
      data[x][y].state = CellState.openState;
    }

    if (checkWin() || checkWin2()) {
      gameState = GameState.win;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success")));
    }
    setState(() {});
  }

  void openLandAround(int i, int j) {
    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (isProper(x, y)) {
          if (data[x][y].no == 0 && data[x][y].state == CellState.closeState) {
            data[x][y].state = CellState.openState;
            openLandAround(x, y);
          } else {
            data[x][y].state = CellState.openState;
          }
        }
      }
    }
  }

  void gameOver() {
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        if (data[i][j].no == 9) {
          data[i][j].state = CellState.openState;

          // Future.delayed(Duration(milliseconds: 100),() =>  data[i][j].state = CellState.openState,);
        }
      }
    }
    gameState = GameState.blast;
  }

  void putFlag({required int i, required int j}) {
    if (data[i][j].state == CellState.flagState) {
      data[i][j].state = CellState.closeState;
      noOfBomb++;
    } else {
      data[i][j].state = CellState.flagState;
      noOfBomb--;
    }

    if (checkWin() || checkWin2()) {
      gameState = GameState.win;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success")));
    }
  }

  bool checkWin() {
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        if (data[i][j].no != 9 && data[i][j].state != CellState.openState) {
          return false;
        }
      }
    }
    return true;
  }

  bool checkWin2() {
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        if ((data[i][j].no != 9 && data[i][j].state == CellState.flagState) ||
            (data[i][j].no == 9 && data[i][j].state != CellState.flagState)) {
          print("$i $j");
          return false;
        }
      }
    }

    return true;
  }

  void autoFlag(int i, int j) {
    //close and flag
    int sum = 0;
    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (isProper(x, y) && data[x][y].state != CellState.openState) {
          sum = sum + 1;
        }
      }
    }
    if (sum != data[i][j].no) {
      return;
    }
    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (isProper(x, y) && data[x][y].state == CellState.closeState) {
          putFlag(i: x, j: y);
        }
      }
    }
  }

  void autoOpen(int i, int j) {
    //close and flag
    int sum = 0;

    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (isProper(x, y) && data[x][y].state == CellState.flagState) {
          sum = sum + 1;
        }
      }
    }

    if (sum != data[i][j].no) {
      return;
    }

    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (isProper(x, y) && data[x][y].state == CellState.closeState) {
          openLand(x, y);
        }
      }
    }
  }

  //----
  bool isProper(int x, int y) =>
      (x >= 0 && x < h) && (y >= 0 && y < w);

//TODO :  Initial Open Done
//TODO :  Redial GameOver
}
