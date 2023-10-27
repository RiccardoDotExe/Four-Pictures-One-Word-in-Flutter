import 'package:flutter/material.dart';

//used for level data on device
import 'package:four_pictures_one_word/sharedpreferences/shared_preference_helper.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/solution_button_widget.dart';
import 'package:four_pictures_one_word/widgets/input_button_widget.dart';

//ALL IN ONE PROVIDER FOR NOW MAYSBE SPLIT IT UP LATER
class LevelProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  //LEVEL PROVIDER
  //level data
  late int _currentLevel = 0;
  final int _maxLevel = 3;

  //used for triggering the win screen
  late bool winScreen = false;

  //used for triggering the animation effect
  int animationTrigger = 0;

  //constructor
  LevelProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
    _currentLevel = getCurrentLevel;
    updateStage();
    notifyListeners();
  }

  //gets the max level
  int get maxLevel {
    return _maxLevel;
  }

  //gets the level from shared preference and sets the variable
  int get getCurrentLevel {
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((statusValue) {
      _currentLevel = statusValue;
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
  String stageName = "EIS";
  List<int> solutionList = [];
  List<bool> buttonEnabledArray = [];

  //list to handle the visibility of the input buttons
  List<bool> visibilityOfButtons = List<bool>.filled(10, true);

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

  //loads the stage data
  void updateStage() {
    if (_currentLevel < levelSolutions.length) {
      animationTrigger = 0;
      stageName = levelSolutions[_currentLevel].toLowerCase();
      visibilityOfButtons = List<bool>.filled(10, true);
      stageName = levelSolutions[_currentLevel];
      solutionList = List<int>.filled(stageName.length, -1);
      buttonEnabledArray = List<bool>.filled(stageName.length, false);
      String buttonText = levelInputButtons[_currentLevel];
      for (int i = 0; i <= 9; i++) {
        buttonLetters[i] = buttonText[i];
      }
      notifyListeners();
    }
  }

  //used to reset the animation effect
  void resetAnimationEffect() {
    animationTrigger = -1;
  }

  //removes the input button from the solution
  void removeInputButton(int buttonNumber) {
    buttonEnabledArray[buttonNumber] = false;
    visibilityOfButtons[solutionList[buttonNumber]] = true;
    solutionList[buttonNumber] = -1;
    notifyListeners();
  }

  //adds the input button to the solution
  void addInputButton(int buttonNumber) {
    int spot = checkAvailableSpot();
    if (spot == -1) {
    } else {
      solutionList[spot] = buttonNumber;
      buttonEnabledArray[spot] = true;
      visibilityOfButtons[buttonNumber] = false;
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
      attempt = attempt + buttonLetters[solutionList[i]];
    }
    //checks if the attempt is correct
    if (attempt == stageName) {
      //checks if the level is the last level
      if (_currentLevel == levelSolutions.length - 1) {
        _currentLevel++;
        updateLevel(_currentLevel);
        resetAnimationEffect();
        winScreen = true;
      }
      //if is not the last level
      else if (_currentLevel < levelSolutions.length - 1) {
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
      if (solutionList[i] == -1) {
        return i;
      }
    }
    return -1;
  }

  //checks if the solution list is full
  bool listFull() {
    for (int i = 0; i < solutionList.length; i++) {
      if (solutionList[i] == -1) {
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
  List<Widget> generateInputButtons(int start, int end) {
    List<Widget> buttons = [];
    buttons.add(const SizedBox(width: 10));
    for (start; start < end; start++) {
      if (start < end) {
        buttons.add(InputButtonWidget(index: start));
        //for space between buttons
        buttons.add(const SizedBox(width: 10));
      }
    }
    return buttons;
  }
}
