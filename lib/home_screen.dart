import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int levelIndex = 0;
  bool isLoaded = false;
  int maxLevel = 3; //hard coded right now but later flexible

  @override
  void initState() {
    loadIntFromPreferences();
    super.initState();
  }

  Future<void> loadIntFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoaded) {
      setState(() {
        levelIndex =
            prefs.getInt('level') ?? 0; // Default value 0 if 'key' is not found
        isLoaded = true;
      });
    }
  }

  void clearIntPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('level');
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Scaffold(
            appBar: AppBar(
              title: const Text('4 pictures 1 word'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Level: ${levelIndex + 1}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (levelIndex < maxLevel) {
                        setState(() {
                          isLoaded = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameScreen(),
                            )).then((value) => loadIntFromPreferences());
                      } else {
                        winScreen();
                      }
                    },
                    child: const Text("PLAY"),
                  ),
                  //Button for debugging
                  ElevatedButton(
                    onPressed: () {
                      clearIntPreference();
                      setState(() {
                        levelIndex = 0;
                      });
                    },
                    child: const Text('RESET'),
                  ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  Future winScreen() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(
                "You played through all $maxLevel levels. Wait for more to come. Congrats!"),
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
