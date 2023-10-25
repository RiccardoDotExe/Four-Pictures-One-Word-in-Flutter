import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:four_pictures_one_word/provider/level_provider.dart';
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

  int _stackIndex = 1; //index for the stack of pictures
  String displayImage = "assets/eis0.jpg"; //placeholder for the zoom in picture

  //method to change from zoom in and out picture
  void changeIndex(int newIndex) {
    setState(() {
      _stackIndex = newIndex;
    });
  }

  //method to change the zoomed in picture
  void changeImage(String newString) {
    setState(() {
      displayImage = newString;
    });
  }

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

  //used to generatea the clickable images
  GestureDetector generateClickableImages(int index) {
    return GestureDetector(
      onTap: () {
        changeIndex(0);
        changeImage("assets/eis1.jpg"); //for the zoomed in picture
      },
      child: Image.asset("assets/eis1.jpg",
          height: 100, width: 100, fit: BoxFit.fill),
    );
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
                    SizedBox(
                      //Images
                      width: 300.0,
                      height: 300.0,
                      child: IndexedStack(
                        index: _stackIndex,
                        children: [
                          GestureDetector(
                            onTap: () {
                              changeIndex(1);
                            },
                            child: SizedBox(
                              width: 300.0,
                              height: 300.0,
                              child: Image.asset(
                                displayImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            children: <Widget>[
                              generateClickableImages(0),
                              generateClickableImages(1),
                              generateClickableImages(2),
                              generateClickableImages(3)
                            ],
                          ),
                        ],
                      ),
                    ),
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
