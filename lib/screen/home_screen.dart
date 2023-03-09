import 'package:flutter/material.dart';
import 'package:mine_swippers/screen/CellModel.dart';
import 'package:mine_swippers/screen/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<List<CellModel>> data = [];
  int noOfBomb = 0;
  bool isAutoFlag = true;
  bool isAutoOpen = true;
  GameState gameState = GameState.general;

  int h=7,w=8;

  @override
  void initState() {
    super.initState();
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 500,
              child: Column(
                children: [
                  for (int i = 0; i < h; i++)
                    Expanded(
                      child: Row(
                        children: [
                          for (int j = 0; j < w; j++) box(i, j),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "⛳️ $noOfBomb",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  setUp();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gameState.restartColor),
                child: Text("Restart")),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Auto Flag",
                  ),
                  SizedBox(width: 10),
                  Switch(
                    value: isAutoFlag,
                    onChanged: (value) {
                      setState(() {
                        isAutoFlag = value;
                      });
                    },
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Auto Open",
                  ),
                  SizedBox(width: 10),
                  Switch(
                    value: isAutoOpen,
                    onChanged: (value) {
                      setState(() {
                        isAutoOpen = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget box(int i, int j) {
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          if (gameState == GameState.general) {
            openLand(i, j);
          }
        },
        onTap: () {
          if (gameState != GameState.general) {
            return;
          }

          if (data[i][j].state == CellState.openState) {
            if (isAutoFlag) {
              autoFlag(i, j);
            }
            if (isAutoOpen) {
              autoOpen(i, j);
            }
          } else {
            putFlag(i: i, j: j);
          }
          setState(() {});
        },
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          color: data[i][j].state == CellState.openState
              ? Colors.brown.shade300
              : (i + j) % 2 == 0
                  ? Colors.green
                  : Colors.lightGreen,
          child: Text({
                CellState.flagState: "🚩",
                CellState.closeState: ""
              }[data[i][j].state] ??
              {0: "", 9: "💣"}[data[i][j].no] ??
              "${data[i][j].no}"),
        ),
      ),
    );
  }
}
