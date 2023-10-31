import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

class ClearWrongHintButonWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ClearWrongHintButonWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClearWrongHintButonWidgetState createState() =>
      _ClearWrongHintButonWidgetState();
}

class _ClearWrongHintButonWidgetState extends State<ClearWrongHintButonWidget> {
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
      //disabled when already used
      onPressed: levelProvider.clearJokerUsed
          ? null
          : () {
              //not enough money
              if (levelProvider.clearWrongLetterCost >
                  levelProvider.getCurrentMoney) {
                levelProvider.moneyScreen(context);
              } else {
                //clear all the wrong buttons
                setState(() {
                  levelProvider.clearAllWrongButtons();
                  levelProvider.clearJokerUsed = true;
                  levelProvider.updateMoney(levelProvider.getCurrentMoney -
                      levelProvider.clearWrongLetterCost);
                });
              }
            },
      //icon and cost
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, size: 17),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${levelProvider.clearWrongLetterCost}",
                  style: const TextStyle(fontSize: 15))
            ]),
          ],
        ),
      ),
    );
  }
}
