import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/widgets/custom_appbar_widget.dart';
import 'package:four_pictures_one_word/widgets/four_images_widget.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';
import 'package:four_pictures_one_word/getX/money_controller.dart';

//game screen
import 'package:four_pictures_one_word/screens/game_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final moneyController = Get.put(MoneyController());
  final levelController = Get.put(LevelController());

  int firstLoad = 0;

  //to check if the screen is loaded for the first time
  bool firstTimeLoaded() {
    if (firstLoad <= 1) {
      firstLoad += 1;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, const Text("4 Pictures 1 Word")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (Obx(() => Text(
                  "Level: ${levelController.level.value + 1}",
                  style: const TextStyle(fontSize: 20),
                ))),
            GestureDetector(
              onTap: () {
                playButtonMethod();
              },
              child: Column(children: [
                const SizedBox(height: 10),
                FourImagesWidget(),
                const SizedBox(height: 10),
                //play button
                ElevatedButton(
                  onPressed: () {
                    playButtonMethod();
                  },
                  child: const Text("PLAY"),
                ),
              ]),
            ),
            ElevatedButton(
              onPressed: () {
                moneyController.changeCurrency(100);
                levelController.deleteLevel();
                levelController.updateStage();
              },
              child: const Text('RESET'),
            ),
          ],
        ),
      ),
    );
  }

  //play button check if the user has played through all levels
  void playButtonMethod() {
    if (levelController.level.value < levelController.maxLevel) {
      levelController.updateStage();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const GameScreen()))
          .then((value) => levelController.updateStage());
    } else {
      winScreen();
    }
  }

  //pop up when the user plays through all levels
  Future winScreen() {
    final levelController = Get.put(LevelController());
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  const Text("Congratulations!", textAlign: TextAlign.center),
              content: Text(
                  "You played through all ${levelController.maxLevel} levels. \n Wait for more to come.",
                  textAlign: TextAlign.center),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); //out of pop up
                        },
                        child: const Text("go back to menu")),
                  ],
                )
              ],
            ));
  }
}
