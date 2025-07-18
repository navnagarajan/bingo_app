import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final int value;
  final Function(int) onClick;
  final bool isSelected;

  const NumberBox(this.value, this.onClick, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed:
            isSelected
                ? null
                : () {
                  onClick(value);
                },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(50, 50),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
        child: Text("$value"),
      ),
    );
  }
}
