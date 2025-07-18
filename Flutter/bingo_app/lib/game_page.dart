import 'dart:async';
import 'dart:math';

import 'package:bingo_app/number_box.dart';
import 'package:bingo_app/result_banner.dart';
import 'package:confetti/confetti.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<List<int>> _selections = List.empty(growable: true);
  final List<int> _mSelectedItems = List.empty(growable: true);

  final mPointDisplayCtrl = StreamController<String?>.broadcast();
  final mNumbersDisplayCtrl = StreamController<String?>.broadcast();
  final ConfettiController confettiController = ConfettiController();
  final List<int> numbers = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
  ];

  @override
  void initState() {
    super.initState();
  }

  int mObtainedPoints = 0;

  void _verify() {
    Future.delayed(Duration(milliseconds: 200), () async {
      int previousPoint = mObtainedPoints;
      mObtainedPoints = 0;
      for (int x = 0; x < 5; x++) {
        int row = 0;
        int column = 0;

        for (int y = 0; y < 5; y++) {
          if (_mSelectedItems.contains(_selections[x][y])) {
            row++;
          }

          if (_mSelectedItems.contains(_selections[y][x])) {
            column++;
          }
        }

        if (row == 5) {
          mObtainedPoints++;
        }

        if (column == 5) {
          mObtainedPoints++;
        }
      }

      int leftToRight = 0;
      for (int i = 0; i < 5; i++) {
        if (!_mSelectedItems.contains(_selections[i][i])) {
          break;
        }
        leftToRight++;
      }

      if (leftToRight == 5) mObtainedPoints++;

      int rightToLeft = 0;
      for (int i = 0; i < 5; i++) {
        int value = 4 - i;
        if (!_mSelectedItems.contains(_selections[value][i])) {
          break;
        }
        rightToLeft++;
      }

      if (rightToLeft == 5) mObtainedPoints++;

      if (previousPoint != mObtainedPoints) {
        mPointDisplayCtrl.sink.add(null);
      }

      if (mObtainedPoints >= 5) {
        isGameCompleted = true;
        confettiController.play();
        await Future.delayed(Duration(seconds: 3));
        confettiController.stop();
      }
    });
  }

  void _onNew() {
    numbers.shuffle(Random());

    _reset();

    for (int row = 0; row < 5; row++) {
      List<int> myList = List.empty(growable: true);
      for (int column = 0; column < 5; column++) {
        myList.add(numbers[((row * 5) + column)]);
      }
      _selections.add(myList);
    }

    setState(() {});
  }

  bool isGameCompleted = false;

  void _reset() {
    _selections.clear();
    _mSelectedItems.clear();
    mObtainedPoints = 0;
    mPointDisplayCtrl.sink.add(null);
    mNumbersDisplayCtrl.sink.add(null);
    isGameCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<String?>(
                  stream: mPointDisplayCtrl.stream,
                  builder: (context, snapshot) {
                    return ResultBanner(mObtainedPoints);
                  },
                ),

                SizedBox(height: 100.0),
                _selections.isEmpty
                    ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(150, 50),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                      onPressed: () {
                        _onNew();
                      },
                      child: Text("Generate"),
                    )
                    : StreamBuilder<String?>(
                      stream: mNumbersDisplayCtrl.stream,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int x = 0; x < _selections.length; x++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:
                                    _selections[x]
                                        .map(
                                          (element) => NumberBox(
                                            element,
                                            (value) {
                                              _mSelectedItems.add(value);
                                              mNumbersDisplayCtrl.sink.add(
                                                null,
                                              );
                                              _verify();
                                            },
                                            _mSelectedItems.contains(element),
                                          ),
                                        )
                                        .toList(),
                              ),
                          ],
                        );
                      },
                    ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _onNew();
              },
              tooltip: "Reset",
              child: Icon(Icons.restore_sharp),
            ),
          ),
          ConfettiWidget(
            confettiController: confettiController,
            shouldLoop: false,
            blastDirection: pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 250,
            emissionFrequency: 0.0,
          ),
        ],
      ),
    );
  }

  Widget buildText(String value) {
    Color? clr;

    switch (value) {
      case "B":
        clr = mObtainedPoints >= 1 ? Colors.green : Colors.black;
        break;
      case "I":
        clr = mObtainedPoints >= 2 ? Colors.green : Colors.black;
        break;
      case "N":
        clr = mObtainedPoints >= 3 ? Colors.green : Colors.black;
        break;
      case "G":
        clr = mObtainedPoints >= 4 ? Colors.green : Colors.black;
        break;
      case "O":
        clr = mObtainedPoints >= 5 ? Colors.green : Colors.black;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        style: TextStyle(fontFamily: 'Bungee', fontSize: 38, color: clr),
      ),
    );
  }

  // Widget getButton(int pValue) {
  //   return Container(
  //     margin: EdgeInsets.all(4.0),
  //     child: ElevatedButton(
  //       onPressed:
  //           _mSelectedItems.contains(pValue)
  //               ? null
  //               : () {
  //                 if (isGameCompleted) return;
  //
  //                 _mSelectedItems.add(pValue);
  //                 mNumbersDisplayCtrl.sink.add(null);
  //                 _verify();
  //               },
  //       style: ElevatedButton.styleFrom(
  //         fixedSize: Size(50, 50),
  //         padding: EdgeInsets.zero,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(7.0),
  //         ),
  //       ),
  //       child: Text("$pValue"),
  //     ),
  //   );
  // }
}
