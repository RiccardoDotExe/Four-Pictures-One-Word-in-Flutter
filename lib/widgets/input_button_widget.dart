import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

class InputButtonWidget extends StatefulWidget {
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  InputButtonWidget({super.key, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _InputButtonWidgetState createState() => _InputButtonWidgetState();
}

class _InputButtonWidgetState extends State<InputButtonWidget> {
  //button style
  final ButtonStyle inputStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16),
      minimumSize: const Size(50, 50),
      maximumSize: const Size(50, 50));

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);
    //visibility widget to turn on and off the buttons
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      //checks with the index to see if the button should be visible
      visible: levelProvider.visibilityOfButtons[widget.index],
      child: ElevatedButton(
        style: inputStyle,
        onPressed: () {
          setState(() {
            levelProvider.addInputButton(widget.index);
          });
          //checks if the win screen should be triggered
          if (levelProvider.winScreen) {
            levelProvider.winScreen = false;
            winScreen();
          }
        },
        //gets the letter from the provider
        child: Text(levelProvider.buttonLetters[widget.index]),
      ),
    );
  }

  //win screen
  Future winScreen() => showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
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
                        Navigator.pop(context); //out of show dialog
                        Navigator.pop(context); //out of game screen
                      },
                      child: const Text("go back to menu")),
                ],
              )
            ],
          ));
}
