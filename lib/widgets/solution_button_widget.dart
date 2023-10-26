import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

class SolutionButtonWidget extends StatefulWidget {
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  SolutionButtonWidget({super.key, required this.index});

  @override
  State<SolutionButtonWidget> createState() => _SolutionButtonWidgetState();
}

class _SolutionButtonWidgetState extends State<SolutionButtonWidget> {
  final ButtonStyle solutionStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      minimumSize: const Size(42, 42),
      maximumSize: const Size(42, 42));

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);
    final solutionList = levelProvider.solutionList; // GET SOLUTION LIST
    final buttonEnabledArray =
        levelProvider.buttonEnabledArray; // GET ENABLE ARRAY LIST

    return ElevatedButton(
      style: solutionStyle,
      onPressed: buttonEnabledArray[widget.index]
          ? () => levelProvider.removeInputButton(widget.index)
          : null,
      child: Text(levelProvider.buttonLetters[solutionList[widget.index]]),
    );
  }
}
