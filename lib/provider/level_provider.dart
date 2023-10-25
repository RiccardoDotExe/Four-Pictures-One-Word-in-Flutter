import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/sharedpreferences/shared_preference_helper.dart';

class LevelProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  //level provider
  late int _currentLevel = 0;
  final int _maxLevel = 3;

  LevelProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
    _currentLevel = getCurrentLevel;
    updateStage();
    notifyListeners();
  }

  int get maxLevel {
    return _maxLevel;
  }

  int get getCurrentLevel {
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((statusValue) {
      _currentLevel = statusValue;
    });
    return _currentLevel;
  }

  void updateLevel(int level) {
    _sharedPrefsHelper.changeLevel(level);
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((levelStatus) {
      _currentLevel = levelStatus;
    });

    notifyListeners();
  }

  void clearLevel() {
    _sharedPrefsHelper.deleteLevel();
    _sharedPrefsHelper.getCurrentLevelFromSharedPreference.then((levelStatus) {
      _currentLevel = levelStatus;
    });

    notifyListeners();
  }

  //button provider
  String stageName = "EIS";
  List<int> solutionList = [];
  List<bool> buttonEnabledArray = [];

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

  void updateStage() {
    if (_currentLevel < levelSolutions.length) {
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

  void removeInputButton(int buttonNumber) {
    buttonEnabledArray[buttonNumber] = false;
    visibilityOfButtons[solutionList[buttonNumber]] = true;
    solutionList[buttonNumber] = -1;
    notifyListeners();
  }

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

  void attemptCheck() {
    String attempt = "";
    for (int i = 0; i < stageName.length; i++) {
      attempt = attempt + buttonLetters[solutionList[i]];
    }
    if (attempt == stageName) {
      //print("Right!");
      if (_currentLevel == levelSolutions.length - 1) {
        _currentLevel++;
        updateLevel(_currentLevel);

        //winScreen();
      } else if (_currentLevel < levelSolutions.length - 1) {
        _currentLevel++;
        updateLevel(_currentLevel);
        updateStage();
      }
    } else {
      //print("Wrong!");
      //do shake effect
      /*
      setState(() {
        shakeEffect = shakeEffect + 2;
      });*/
    }
    notifyListeners();
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
}
