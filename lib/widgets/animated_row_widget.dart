import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

//for animations
import 'package:flutter_animate/flutter_animate.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/solution_button_widget.dart';

class AnimatedSolutionRow extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AnimatedSolutionRow({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedSolutionRowState createState() => _AnimatedSolutionRowState();
}

class _AnimatedSolutionRowState extends State<AnimatedSolutionRow> {
  @override
  Widget build(BuildContext context) {
    final levelController = Get.put(LevelController());
    //animate effect when solution is wrong
    return Obx(() => Animate(
          effects: [
            ShakeEffect(
              duration: 100.ms,
              hz: 35,
            ),
            TintEffect(
              duration: 100.ms,
              color: const Color.fromARGB(169, 242, 55, 55),
            ),
          ],
          //handles the animation trigger
          target: (levelController.animationTrigger == 1) ? 1 : 0,
          onComplete: (controller) {
            setState(() {
              levelController.animationTrigger =
                  levelController.animationTrigger - 1;
            });
          },
          //row scales with amount of solution letters and screen width
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: generateSolutionButtons(),
              ),
            ),
          ),
        ));
  }
}
