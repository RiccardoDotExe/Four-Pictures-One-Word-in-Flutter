import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

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
    final levelController = Get.put(LevelController());
    //visibility widget to turn on and off the buttons
    return Obx(
      () => Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        //checks with the index to see if the button should be visible
        visible:
            (levelController.buttonList[widget.index].usedCurrently == false),
        child: ElevatedButton(
          style: inputStyle,
          onPressed: () {
            setState(() {
              levelController.addInputButton(widget.index);
            });
            //checks if the win screen should be triggered
            if (levelController.winScreen) {
              levelController.winScreen = false;
              winScreen();
            }
          },
          //gets the letter from the provider
          child: Text(
            levelController.buttonList[widget.index].letter.toUpperCase(),
          ),
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
                    child: const Text("go back to menu"),
                  ),
                ],
              ),
            ],
          ));
}

//used to generate the input buttons
List<Widget> generateInputButtons(int start, int end, Widget widget) {
  List<Widget> buttons = [];
  buttons.add(const SizedBox(width: 10));
  for (start; start < end; start++) {
    if (start < end) {
      buttons.add(InputButtonWidget(index: start));
      //for space between buttons
      buttons.add(const SizedBox(width: 10));
    }
  }
  buttons.add(widget);
  buttons.add(const SizedBox(width: 10));
  return buttons;
}
