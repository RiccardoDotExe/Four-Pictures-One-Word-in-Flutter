import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int levelIndex = 0; //used as index for level
  late String stageName = "blank"; //used for loading images
  int shakeEffect = 0;

  void saveIntToPreferences(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('level', value);
  }

  Future<void> loadIntFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      levelIndex = prefs.getInt('level') ?? 0;
      updateState();
    });
  }

  void clearIntPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('level');
  }

  //initialize all variables
  @override
  void initState() {
    updateState();
    loadIntFromPreferences();
    super.initState();
  }

  //update all variables
  void updateState() {
    setState(() {
      stageName = levelSolutions[levelIndex].toLowerCase();
      visibilityOfButtons = List<bool>.filled(10, true);
      actualSolution = levelSolutions[levelIndex];
      solutionList = List<int>.filled(actualSolution.length, -1);
      buttonEnabledArray = List<bool>.filled(actualSolution.length, false);
      String buttonText = levelInputButtons[levelIndex];
      for (int i = 0; i <= 9; i++) {
        buttonLetters[i] = buttonText[i];
      }
    });
  }

  //button styles
  final ButtonStyle inputStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(50, 50),
      maximumSize: const Size(50, 50));
  final ButtonStyle solutionStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      minimumSize: const Size(42, 42),
      maximumSize: const Size(42, 42));
  final ButtonStyle checkButtonStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  String actualSolution = "";
  List<int> solutionList = [];
  List<bool> buttonEnabledArray = [];

  //data with all solutions according to level
  final Map<int, dynamic> levelSolutions = {0: 'EIS', 1: 'TRINKEN', 2: 'LIEBE'};

  // data for input buttons
  final Map<int, dynamic> levelInputButtons = {
    0: 'SLTEIAKREF',
    1: 'NIRLOKMNET',
    2: 'ILBPETEAFK'
  };

  //live button key data: -1 for empty
  Map<int, dynamic> buttonLetters = {
    -1: '',
    0: '0',
    1: '0',
    2: '0',
    3: '0',
    4: '0',
    5: '0',
    6: '0',
    7: '0',
    8: '0',
    9: '0'
  };

  int _stackIndex = 1; //index for the stack of pictures
  String displayImage = "assets/eis0.jpg"; //placeholder for the zoom in picture

  //method to change from zoom in and out picture
  void changeIndex(int newIndex) {
    setState(() {
      _stackIndex = newIndex;
    });
  }

  //method to change the zoomed in picture
  void changeImage(String newString) {
    setState(() {
      displayImage = newString;
    });
  }

  List<bool> visibilityOfButtons = List<bool>.filled(10, true);

  //used to generate the input buttons
  Visibility buildInputVisibilityButton(int index) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: visibilityOfButtons[index],
      child: ElevatedButton(
        style: inputStyle,
        onPressed: () {
          setState(() {
            addInputButton(index);
          });
        },
        child: Text(buttonLetters[index]),
      ),
    );
  }

  //solution button template
  ElevatedButton buildSolutionButton(int index) {
    return ElevatedButton(
      style: solutionStyle,
      onPressed:
          //ternary operator that decides if the button is disabled or enabled
          buttonEnabledArray[index] ? () => removeInputButton(index) : null,
      child: Text(buttonLetters[solutionList[index]]),
    );
  }

  //used to generate the solution buttons
  List<Widget> generateSolutionButtons(int numberOfButtons) {
    List<Widget> buttons = [];
    for (int i = 0; i < numberOfButtons; i++) {
      buttons.add(buildSolutionButton(i));
      //for space between buttons
      if (i < numberOfButtons - 1) {
        buttons.add(const SizedBox(width: 5));
      }
    }
    return buttons;
  }

  //used to generatea the clickable images
  GestureDetector generateClickableImages(int index) {
    return GestureDetector(
      onTap: () {
        changeIndex(0);
        changeImage("assets/$stageName$index.jpg"); //for the zoomed in picture
      },
      child: Image.asset("assets/$stageName$index.jpg",
          height: 100, width: 100, fit: BoxFit.fill),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${levelIndex + 1}"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              //Images
              width: 300.0,
              height: 300.0,
              child: IndexedStack(
                index: _stackIndex,
                children: [
                  GestureDetector(
                    onTap: () {
                      changeIndex(1);
                    },
                    child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: Image.asset(
                        displayImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    children: <Widget>[
                      generateClickableImages(0),
                      generateClickableImages(1),
                      generateClickableImages(2),
                      generateClickableImages(3)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: generateSolutionButtons(actualSolution.length),
            )
                .animate(
                  target: (shakeEffect == 1) ? 1 : 0,
                  onComplete: (controller) {
                    setState(() {
                      //print(_over.toString() + " in method 1");
                      shakeEffect = shakeEffect - 1;
                      //print(_over.toString() + " in method 2");
                    });
                  },
                )
                .tint(
                    color: const Color.fromARGB(169, 244, 54, 54),
                    duration: 100.ms)
                .shake(hz: 35),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildInputVisibilityButton(0),
                const SizedBox(width: 10),
                buildInputVisibilityButton(1),
                const SizedBox(width: 10),
                buildInputVisibilityButton(2),
                const SizedBox(width: 10),
                buildInputVisibilityButton(3),
                const SizedBox(width: 10),
                buildInputVisibilityButton(4)
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildInputVisibilityButton(5),
                const SizedBox(width: 10),
                buildInputVisibilityButton(6),
                const SizedBox(width: 10),
                buildInputVisibilityButton(7),
                const SizedBox(width: 10),
                buildInputVisibilityButton(8),
                const SizedBox(width: 10),
                buildInputVisibilityButton(9)
              ],
            ),
            const SizedBox(height: 20),
            //Button for debugging
            ElevatedButton(
              style: checkButtonStyle,
              onPressed: () {
                clearIntPreference();
                Navigator.pop(context);
              },
              child: const Text('RESET'),
            ),
          ],
        ),
      ),
    );
  }

  void solutionButton() {
    String attempt = "";
    for (int i = 0; i < actualSolution.length; i++) {
      attempt = attempt + buttonLetters[solutionList[i]];
    }
    if (attempt == actualSolution) {
      //print("Right!");
      if (levelIndex == levelSolutions.length - 1) {
        levelIndex++;
        saveIntToPreferences(levelIndex);
        winScreen();
      } else if (levelIndex < levelSolutions.length - 1) {
        levelIndex++;
        updateState();
        saveIntToPreferences(levelIndex);
      }
    } else {
      //print("Wrong!");
      setState(() {
        shakeEffect = shakeEffect + 2;
      });
    }
  }

  void removeInputButton(int arrayNumber) {
    setState(() {
      buttonEnabledArray[arrayNumber] = false;
      visibilityOfButtons[solutionList[arrayNumber]] = true;
      solutionList[arrayNumber] = -1;
    });
  }

  void addInputButton(int buttonNumber) {
    int spot = checkAvailableSpot();
    if (spot == -1) {
    } else {
      solutionList[spot] = buttonNumber;
      buttonEnabledArray[spot] = true;
      visibilityOfButtons[buttonNumber] = false;
      if (listFull()) {
        solutionButton();
      }
    }
  }

  int checkAvailableSpot() {
    for (int i = 0; i < solutionList.length; i++) {
      if (solutionList[i] == -1) {
        return i;
      }
    }
    return -1;
  }

  bool listFull() {
    for (int i = 0; i < solutionList.length; i++) {
      if (solutionList[i] == -1) {
        return false;
      }
    }
    return true;
  }

  Future winScreen() => showDialog(
      context: context,
      barrierDismissible: false,
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
                        Navigator.pop(context); //out of pop up
                        Navigator.pop(context); //out of game screen
                      },
                      child: const Text("go back to menu")),
                ],
              )
            ],
          ));
}
