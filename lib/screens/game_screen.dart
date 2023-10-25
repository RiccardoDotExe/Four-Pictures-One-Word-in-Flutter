import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:four_pictures_one_word/provider/level_provider.dart';
import 'package:four_pictures_one_word/widgets/image_stack_widget.dart';
import 'package:four_pictures_one_word/widgets/input_button_widget.dart';
import 'package:four_pictures_one_word/widgets/solution_button_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int shakeEffect = 0;

  //used to generate the solution buttons
  List<Widget> generateSolutionButtons(int numberOfButtons) {
    List<Widget> buttons = [];
    for (int i = 0; i < numberOfButtons; i++) {
      //for space between buttons
      if (i < numberOfButtons) {
        buttons.add(SolutionButtonWidget(index: i));
        buttons.add(const SizedBox(width: 5));
      }
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
        builder: (context, levelProvider, child) => Scaffold(
              appBar: AppBar(
                title: Text("${levelProvider.getCurrentLevel + 1}"),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ImageStackWidget(stageName: levelProvider.stageName),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: generateSolutionButtons(
                          levelProvider.solutionList.length),
                    )
                        //Shake effect but unused right now
                        .animate(
                          target: (shakeEffect == 1) ? 1 : 0,
                          onComplete: (controller) {
                            setState(() {
                              //print(_over.toString() + " in method 1");
                              shakeEffect = shakeEffect - 1;
                              //print(_over.toString() + " in method 2");
                            });
                          },
                        )
                        .tint(
                            color: const Color.fromARGB(169, 244, 54, 54),
                            duration: 100.ms)
                        .shake(hz: 35),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InputButtonWidget(index: 0),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 1),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 2),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 3),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 4),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InputButtonWidget(index: 5),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 6),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 7),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 8),
                        const SizedBox(width: 10),
                        InputButtonWidget(index: 9),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: true,
                          child: ElevatedButton(
                            onPressed: () {
                              levelProvider.clearLevel();
                              Navigator.pop(context);
                            },
                            child: const Text('reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  Future winScreen() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("YOU WON!"),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); //out of pop up
                        Navigator.pop(context); //out of game screen
                      },
                      child: const Text("go back to menu")),
                ],
              )
            ],
          ));
}
