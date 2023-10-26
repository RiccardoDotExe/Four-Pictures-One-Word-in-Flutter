import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';
import 'package:provider/provider.dart';

class InputButtonWidget extends StatefulWidget {
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  InputButtonWidget({super.key, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _InputButtonWidgetState createState() => _InputButtonWidgetState();
}

class _InputButtonWidgetState extends State<InputButtonWidget> {
  final ButtonStyle inputStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(50, 50),
      maximumSize: const Size(50, 50));

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: levelProvider.visibilityOfButtons[widget.index],
      child: ElevatedButton(
        style: inputStyle,
        onPressed: () {
          setState(() {
            levelProvider.addInputButton(widget.index);
          });
          if (levelProvider.winScreen) {
            levelProvider.winScreen = false;
            winScreen();
          }
        },
        child: Text(levelProvider.buttonLetters[widget.index]),
      ),
    );
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
