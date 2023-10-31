import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

class CorrectLetterHintButtonWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CorrectLetterHintButtonWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CorrectLetterHintButtonWidgetState createState() =>
      _CorrectLetterHintButtonWidgetState();
}

class _CorrectLetterHintButtonWidgetState
    extends State<CorrectLetterHintButtonWidget> {
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
        //not enough money
        if (levelProvider.correctLetterCost > levelProvider.getCurrentMoney) {
          levelProvider.moneyScreen(context);
        } else {
          setState(() {
            //set one correct letter in order
            levelProvider.correctLetterHintButton();
            levelProvider.updateMoney(levelProvider.getCurrentMoney -
                levelProvider.correctLetterCost);
          });
        }
        //checks if the win screen should be triggered
        if (levelProvider.winScreen) {
          levelProvider.winScreen = false;
          winScreen();
        }
      },
      //icon and cost
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb, size: 17),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${levelProvider.correctLetterCost}",
                  style: const TextStyle(fontSize: 15))
            ]),
          ],
        ),
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
