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

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);

    //get data from provider
    final solutionList = levelProvider.solutionList;
    final buttonEnabledArray = levelProvider.buttonEnabledArray;

    return ElevatedButton(
      style: solutionStyle,
      //checks if the button is enabled and give it a function accordingly
      onPressed: buttonEnabledArray[widget.index]
          ? () => levelProvider.removeInputButton(widget.index)
          : null,
      //gets the letter from the provider
      child: Text(levelProvider.buttonLetters[solutionList[widget.index]]),
    );
  }
}
