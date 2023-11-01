import 'package:flutter/material.dart';

//datatypes
import 'package:four_pictures_one_word/datatypes/button.dart';
import 'package:four_pictures_one_word/datatypes/level.dart';

//used for level data on device
import 'package:four_pictures_one_word/data/shared_preference_helper.dart';
import 'package:four_pictures_one_word/data/database_helper.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/solution_button_widget.dart';
import 'package:four_pictures_one_word/widgets/input_button_widget.dart';
import 'package:four_pictures_one_word/widgets/money_tapper_widget.dart';

//ALL IN ONE PROVIDER FOR NOW MAYSBE SPLIT IT UP LATER
class LevelProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;
  late DatabaseHelper _databaseHelper;

  //for level data from firestore
  late List<Level> levelList = [];

  //LEVEL PROVIDER
  //level data
  late int _currentLevel = 0;
  late int _maxLevel = 3; // gets updated when data is loaded

  //used for triggering the win screen
  late bool winScreen = false;
  bool clearJokerUsed = false;

  //used for triggering the animation effect
  int animationTrigger = 0;

  //constructor
  LevelProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
    _databaseHelper = DatabaseHelper();
    initializeData();
    _money = getCurrentMoney;
    _currentLevel = getCurrentLevel;
    updateStage();
    notifyListeners();
  }

  //data with all solutions according to level
  Map<int, dynamic> levelSolutions = {};

  // data for input buttons
  Map<int, dynamic> levelInputButtons = {};

  //get data from database and load it into variables
  Future initializeData() async {
    await _databaseHelper.loadLevels();
    levelList = await _databaseHelper.getLevels;
    for (int i = 0; i < levelList.length; i++) {
      levelSolutions[i] = levelList[i].name.toLowerCase();
      levelInputButtons[i] = levelList[i].inputButtons.toLowerCase();
    }
    _maxLevel = levelSolutions.length;
  }

  //gets the max level
  int get maxLevel {
    return _maxLevel;
  }

  //gets the level from shared preference and sets the variable
  int get getCurrentLevel {
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((levelStatus) {
      _currentLevel = levelStatus;
    });
    return _currentLevel;
  }

  //upadtes the level variable and shared preference with a value
  void updateLevel(int level) {
    _sharedPrefsHelper.changeLevel(level);
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((levelStatus) {
      _currentLevel = levelStatus;
    });
    notifyListeners();
  }

  //clears the level variable and shared preference
  void clearLevel() {
    _sharedPrefsHelper.deleteLevel();
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((levelStatus) {
      _currentLevel = levelStatus;
    });
    notifyListeners();
  }

  //BUTTON PROVIDER
  //data for the buttons
  String stageName = "";
  List<Button> solutionList = [];
  List<Button> buttonList = [];

  //loads the stage data
  void updateStage() {
    if (_currentLevel < levelSolutions.length) {
      animationTrigger = 0;
      clearJokerUsed = false;
      stageName = levelSolutions[_currentLevel].toLowerCase();

      solutionList = [];
      solutionList = List<Button>.filled(
          stageName.length,
          Button(
            buttonID: -1,
            solutionID: -1,
            letter: '',
            usedCurrently: false,
            hinted: false,
            clearedByJoker: false,
          ));

      buttonList = [];
      for (int i = 0; i <= 9; i++) {
        buttonList.add(Button(
          buttonID: i,
          solutionID: -1,
          letter: levelInputButtons[_currentLevel][i],
          usedCurrently: false,
          hinted: false,
          clearedByJoker: false,
        ));
      }

      notifyListeners();
    }
  }

  //add correct letter hint function
  void correctLetterHintButton() {
    bool hintFound = false;
    //loop over solution to find first wrong letter
    for (int i = 0; i < solutionList.length; i++) {
      //if correct go to next
      if (solutionList[i].letter == stageName[i]) {
      }
      //else handle hint
      else {
        //for buttons in the input buttons
        for (int j = 0; j < buttonList.length; j++) {
          if (!buttonList[j].usedCurrently &&
              !buttonList[j].hinted &&
              !buttonList[j].clearedByJoker &&
              !hintFound) {
            if (buttonList[j].letter == stageName[i]) {
              //remove button in wrong spot
              if (!(solutionList[i].buttonID == -1)) {
                removeInputButton(solutionList[i].buttonID, i);
              }
              //add button to the right spot
              buttonList[j].hinted = true;
              addInputButton(j);
              hintFound = true;
              break;
            }
          }
        }
        //for buttons in the solution buttons
        for (int j = 0; j < buttonList.length; j++) {
          if (buttonList[j].usedCurrently &&
              !buttonList[j].hinted &&
              !buttonList[j].clearedByJoker &&
              !hintFound) {
            if (buttonList[j].letter == stageName[i]) {
              //remove button in wrong spot
              if (!(solutionList[i].buttonID == -1)) {
                removeInputButton(solutionList[i].buttonID, i);
              }
              //remove correct button from wrong spot and then add it to the right spot
              buttonList[j].hinted = true;
              removeInputButton(j, buttonList[j].solutionID);
              addInputButton(j);
              hintFound = true;
              break;
            }
          }
        }
      }
    }
    notifyListeners();
  }

  //clear wrong letters hint function
  void clearAllWrongButtons() {
    List<int> rightButtons = [];
    //add right buttons to the rightButtons list
    for (int i = 0; i < stageName.length; i++) {
      for (int j = 0; j < buttonList.length; j++) {
        if (buttonList[j].letter == stageName[i] && !rightButtons.contains(j)) {
          rightButtons.add(j);
          break;
        }
      }
    }
    //remove buttons from the solution if they are not hinted
    for (int i = 0; i < stageName.length; i++) {
      if (!(solutionList[i].buttonID == -1) && !solutionList[i].hinted) {
        removeInputButton(solutionList[i].buttonID, i);
      }
    }
    //at the end makes wrong buttons invisible
    for (int i = 0; i < buttonList.length; i++) {
      if (!rightButtons.contains(i)) {
        buttonList[i].clearedByJoker = true;
        buttonList[i].usedCurrently = true;
      }
    }
    clearJokerUsed = true;
    notifyListeners();
  }

  //used to reset the animation effect
  void resetAnimationEffect() {
    animationTrigger = -1;
  }

  //removes the input button from the solution
  void removeInputButton(int buttonNumber, int solutionNumber) {
    buttonList[buttonNumber].usedCurrently = false;
    buttonList[buttonNumber].solutionID = -1;
    solutionList[solutionNumber] = Button(
      buttonID: -1,
      solutionID: -1,
      letter: '',
      usedCurrently: false,
      hinted: false,
      clearedByJoker: false,
    );
    notifyListeners();
  }

  //adds the input button to the solution
  void addInputButton(int buttonNumber) {
    int spot = checkAvailableSpot();

    if (spot == -1) {
    } else {
      solutionList[spot] = buttonList[buttonNumber];
      buttonList[buttonNumber].usedCurrently = true;
      buttonList[buttonNumber].solutionID = spot;
      if (listFull()) {
        attemptCheck();
      }
    }
    notifyListeners();
  }

  //checks if the solution is correct
  void attemptCheck() {
    //makes a string out of the solution list for the check
    String attempt = "";
    for (int i = 0; i < stageName.length; i++) {
      attempt = attempt + solutionList[i].letter.toLowerCase();
    }
    //checks if the attempt is correct
    if (attempt == stageName) {
      //checks if the level is the last level
      if (_currentLevel == levelSolutions.length - 1) {
        updateMoney(getCurrentMoney + 30);
        _currentLevel++;
        updateLevel(_currentLevel);
        resetAnimationEffect();
        winScreen = true;
      }
      //if is not the last level
      else if (_currentLevel < levelSolutions.length - 1) {
        updateMoney(getCurrentMoney + 30);
        _currentLevel++;
        updateLevel(_currentLevel);
        updateStage();
        resetAnimationEffect();
      }
    }
    //play the animation because the attempt is wrong
    else {
      animationTrigger = animationTrigger + 2;
    }
    notifyListeners();
  }

  //checks if there is an available spot in the solution list
  int checkAvailableSpot() {
    for (int i = 0; i < solutionList.length; i++) {
      if (solutionList[i].buttonID == -1) {
        return i;
      }
    }
    return -1;
  }

  //checks if the solution list is full
  bool listFull() {
    for (int i = 0; i < solutionList.length; i++) {
      if (solutionList[i].buttonID == -1) {
        return false;
      }
    }
    return true;
  }

  //used to generate the solution buttons
  List<Widget> generateSolutionButtons() {
    int numberOfButtons = solutionList.length;
    List<Widget> buttons = [];
    buttons.add(const SizedBox(width: 5));
    for (int i = 0; i < numberOfButtons; i++) {
      if (i < numberOfButtons) {
        buttons.add(SolutionButtonWidget(index: i));
        //for space between buttons
        buttons.add(const SizedBox(width: 5));
      }
    }
    return buttons;
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

  //MONEY PROVIDER
  late int _money = 100;
  int correctLetterCost = 10;
  int clearWrongLetterCost = 20;

  //gets the level from shared preference and sets the variable
  int get getCurrentMoney {
    _sharedPrefsHelper.getCurrentCurrencyFromSharedPreference
        .then((moneyStatus) {
      _money = moneyStatus;
    });
    return _money;
  }

  //upadtes the level variable and shared preference with a value
  void updateMoney(int money) {
    _sharedPrefsHelper.changeCurrency(money);
    _sharedPrefsHelper.getCurrentCurrencyFromSharedPreference
        .then((moneyStatus) {
      _money = moneyStatus;
    });
    notifyListeners();
  }

  //clears the level variable and shared preference
  void clearMoney() {
    _sharedPrefsHelper.deleteCurrency();
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((moneyStatus) {
      _money = moneyStatus;
    });
    notifyListeners();
  }

  //win screen
  Future moneyScreen(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("You got $getCurrentMoney coins! Get more:"),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width * .7,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  MoneyTapperWidget(moneyValue: 10),
                  MoneyTapperWidget(moneyValue: 25),
                  MoneyTapperWidget(moneyValue: 50),
                  MoneyTapperWidget(moneyValue: 100)
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //out of show dialog
                        Navigator.pop(context); //out of game screen
                      },
                      child: const Text("go back")),
                ],
              )
            ],
          ));
}
