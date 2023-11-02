import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';
import 'package:four_pictures_one_word/getX/money_controller.dart';

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
    final moneyController = Get.put(MoneyController());
    final levelController = Get.put(LevelController());

    //hint button
    return Obx(() => ElevatedButton(
          style: inputStyle,
          //disabled when already used
          onPressed: levelController.clearJokerUsed.value
              ? null
              : () {
                  //not enough money
                  if (moneyController.clearWrongLetterCost >
                      moneyController.getCurrentCurrencyFromBox) {
                    moneyController.moneyScreen(context);
                  } else {
                    //clear all the wrong buttons
                    setState(() {
                      levelController.clearAllWrongButtons();
                      levelController.clearJokerUsed.value = true;
                      moneyController
                          .addCurrency(-moneyController.clearWrongLetterCost);
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
                  Text("${moneyController.clearWrongLetterCost}",
                      style: const TextStyle(fontSize: 15))
                ]),
              ],
            ),
          ),
        ));
  }
}
