import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/screens/game_screen.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int initialLevel;
  HomeScreen({super.key, required this.initialLevel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool firstLoad = false;

  //to check if the screen is loaded for the first time
  bool firstTimeLoaded() {
    if (firstLoad == false) {
      firstLoad = true;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
        builder: (context, levelProvider, child) => Scaffold(
              appBar: AppBar(
                title: const Text('4 pictures 1 word'),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "Level: ${firstTimeLoaded() ? levelProvider.getCurrentLevel + 1 : widget.initialLevel + 1}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (levelProvider.getCurrentLevel <
                            levelProvider.maxLevel) {
                          levelProvider.updateStage();
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => const GameScreen()))
                              .then((value) => levelProvider.updateStage());
                        } else {
                          winScreen();
                        }
                      },
                      child: const Text("PLAY"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        levelProvider.updateStage();
                        levelProvider
                            .updateLevel(levelProvider.getCurrentLevel + 1);
                      },
                      child: const Text('increase'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        levelProvider.clearLevel();
                      },
                      child: const Text('reset'),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future winScreen() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: const Text(
                "You played through all 3 levels. Wait for more to come. Congrats!"),
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
