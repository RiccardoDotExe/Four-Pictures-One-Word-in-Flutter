import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

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
    final levelController = Get.put(LevelController());

    return Obx(() => ElevatedButton(
          style: levelController.solutionList[widget.index].hinted == true
              ? hintedStyle
              : solutionStyle,
          //checks if the button is enabled and give it a function accordingly
          onPressed:
              !(levelController.solutionList[widget.index].buttonID == -1 ||
                      levelController.solutionList[widget.index].hinted == true)
                  ? () => setState(() {
                        levelController.removeInputButton(
                            levelController.solutionList[widget.index].buttonID,
                            widget.index);
                      })
                  : null,
          //gets the letter from the provider
          child: Text(
              levelController.solutionList[widget.index].letter.toUpperCase()),
        ));
  }
}

//used to generate the solution buttons
List<Widget> generateSolutionButtons() {
  final levelController = Get.put(LevelController());
  int numberOfButtons = levelController.solutionList.length;
  List<Widget> buttons = [];
  buttons.add(const SizedBox(width: 5));
  for (int i = 0; i < numberOfButtons; i++) {
    if (i < numberOfButtons) {
      buttons.add(SolutionButtonWidget(index: i));
      //for space between buttons
      buttons.add(const SizedBox(width: 5));
    }
  }
  return buttons;
}
