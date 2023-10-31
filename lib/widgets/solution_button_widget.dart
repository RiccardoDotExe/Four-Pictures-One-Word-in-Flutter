import 'package:flutter/material.dart';

//provider
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
  //button style
  final ButtonStyle solutionStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      minimumSize: const Size(42, 42),
      maximumSize: const Size(42, 42));

  final ButtonStyle hintedStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      minimumSize: const Size(42, 42),
      maximumSize: const Size(42, 42),
      disabledForegroundColor: const Color.fromARGB(255, 0, 121, 0),
      disabledBackgroundColor: const Color.fromARGB(255, 167, 255, 170));

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);

    return ElevatedButton(
      style: levelProvider.solutionList[widget.index].hinted
          ? hintedStyle
          : solutionStyle,
      //checks if the button is enabled and give it a function accordingly
      onPressed: !(levelProvider.solutionList[widget.index].buttonID == -1 ||
              levelProvider.solutionList[widget.index].hinted)
          ? () => levelProvider.removeInputButton(
              levelProvider.solutionList[widget.index].buttonID, widget.index)
          : null,
      //gets the letter from the provider
      child:
          Text(levelProvider.solutionList[widget.index].letter.toUpperCase()),
    );
  }
}
