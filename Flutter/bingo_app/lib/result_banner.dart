import 'package:flutter/material.dart';

class ResultBanner extends StatelessWidget {
  final int score;
  final List<String> label;

  const ResultBanner(this.score, {super.key})
    : label = const ["B", "I", "N", "G", "O"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(label.length, (index) => getText(index)),
        ),

        if (score >= 5)
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, size: 38, color: Colors.green),
                    Text(
                      "You WIN",
                      style: TextStyle(fontFamily: 'Bungee', fontSize: 38),
                    ),
                    Icon(Icons.verified, size: 38, color: Colors.green),
                  ],
                ),
                Text(
                  "... please reset for new game ...",
                  style: TextStyle(
                    color: Colors.black38,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget getText(int pIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label[pIndex],
        style: TextStyle(
          fontSize: 38.0,
          fontFamily: 'Bungee',
          color: pIndex < score ? Colors.green : Colors.black38,
        ),
      ),
    );
  }
}
