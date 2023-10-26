import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:four_pictures_one_word/provider/level_provider.dart';
import 'package:four_pictures_one_word/widgets/image_stack_widget.dart';
import 'package:four_pictures_one_word/widgets/input_button_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
        builder: (context, levelProvider, child) => Scaffold(
              appBar: AppBar(
                title: Text("Level: ${levelProvider.getCurrentLevel + 1}"),
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
                      children: levelProvider.generateSolutionButtons(),
                    )
                        .animate(
                          target: (levelProvider.shakeEffect == 1) ? 1 : 0,
                          onComplete: (controller) {
                            setState(() {
                              //print(levelProvider.shakeEffect.toString() +" in method 1");
                              levelProvider.shakeEffect =
                                  levelProvider.shakeEffect - 1;
                              //print(levelProvider.shakeEffect.toString() +" in method 2");
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

                    //for testing purposes
                    /*
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
                    */
                  ],
                ),
              ),
            ));
  }
}
