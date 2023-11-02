import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/custom_appbar_widget.dart';
import 'package:four_pictures_one_word/widgets/input_button_widget.dart';
import 'package:four_pictures_one_word/widgets/center_row_widget.dart';
import 'package:four_pictures_one_word/widgets/animated_row_widget.dart';
import 'package:four_pictures_one_word/widgets/image_stack_widget.dart';
import 'package:four_pictures_one_word/widgets/correct_letter_hint_button_widget.dart';
import 'package:four_pictures_one_word/widgets/clear_wrong_hint_button_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final levelController = Get.put(LevelController());
    return Scaffold(
      //app bar with current level and money
      appBar: buildCustomAppBar(context,
          (Obx(() => Text("Level: ${levelController.level.value + 1}")))),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              children: <Widget>[
                ImageStackWidget(),
                const SizedBox(height: 20),
                AnimatedSolutionRow(),
                const SizedBox(height: 20),
                CustomCenterRow(
                    widgets: generateInputButtons(
                        0, 5, CorrectLetterHintButtonWidget())),
                const SizedBox(height: 10),
                CustomCenterRow(
                    widgets: generateInputButtons(
                        5, 10, ClearWrongHintButonWidget())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
