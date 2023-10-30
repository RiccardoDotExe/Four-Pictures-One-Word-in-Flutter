import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/center_row.dart';
import 'package:four_pictures_one_word/widgets/animated_row.dart';
import 'package:four_pictures_one_word/widgets/image_stack_widget.dart';
import 'package:four_pictures_one_word/widgets/hint_button_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
        builder: (context, levelProvider, child) => Scaffold(
              //app bar with current level
              appBar: AppBar(
                title: Text("Level: ${levelProvider.getCurrentLevel + 1}"),
                centerTitle: true,
              ),
              body: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: <Widget>[
                        ImageStackWidget(stageName: levelProvider.stageName),
                        const SizedBox(height: 20),
                        AnimatedSolutionRow(),
                        const SizedBox(height: 20),
                        CustomCenterRow(
                            widgets: levelProvider.generateInputButtons(
                                0, 5, HintButtonWidget())),
                        const SizedBox(height: 10),
                        CustomCenterRow(
                            widgets: levelProvider.generateInputButtons(
                                5, 10, HintButtonWidget())),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
