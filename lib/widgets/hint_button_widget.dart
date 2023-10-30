import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

class HintButtonWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HintButtonWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HintButtonWidgetState createState() => _HintButtonWidgetState();
}

class _HintButtonWidgetState extends State<HintButtonWidget> {
  //button style
  final ButtonStyle inputStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16),
      minimumSize: const Size(50, 50),
      maximumSize: const Size(50, 50),
      backgroundColor: Colors.green);

  @override
  Widget build(BuildContext context) {
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);

    //hint button
    return ElevatedButton(
      style: inputStyle,
      onPressed: () {
        setState(() {
          levelProvider.hintButton();
        });
        //checks if the win screen should be triggered
        if (levelProvider.winScreen) {
          levelProvider.winScreen = false;
          winScreen();
        }
      },
      //later maybe an icon instead of text
      child: const Text("H"),
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
