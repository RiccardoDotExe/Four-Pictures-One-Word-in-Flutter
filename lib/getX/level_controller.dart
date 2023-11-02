//getx
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/money_controller.dart';

//database
import 'package:four_pictures_one_word/data/database_helper.dart';

//custom datatypes
import 'package:four_pictures_one_word/datatypes/button.dart';
import 'package:four_pictures_one_word/datatypes/level.dart';

class LevelController extends GetxController {
  late DatabaseHelper _databaseHelper;

  //getx storage and controller
  final box = GetStorage();
  final moneyController = Get.put(MoneyController());

  //name of the saved box variable
  static const String currentLevelName = "currentLevel";

  //level data
  var level = 0.obs;
  int maxLevel = 100;

  //for level data from firestore
  late List<Level> levelList = [];

  //data with all solutions according to level
  Map<int, dynamic> levelSolutions = {};

  // data for input buttons
  Map<int, dynamic> levelInputButtons = {};

  //data for the buttons
  RxString stageName = "".obs;
  RxList<Button> solutionList = <Button>[].obs;
  RxList<Button> buttonList = <Button>[].obs;

  //used for triggering the win screen
  late bool winScreen = false;
  RxBool clearJokerUsed = false.obs;

  //used for triggering the animation effect
  int animationTrigger = 0;

  //initializes the data
  @override
  void onInit() {
    super.onInit();
    _databaseHelper = DatabaseHelper();
    initializeData();
    level.value = getCurrentLevelFromBox;
    updateStage();
  }

  //get data from database and load it into variables
  Future initializeData() async {
    await _databaseHelper.loadLevels();
    levelList = await _databaseHelper.getLevels;
    for (int i = 0; i < levelList.length; i++) {
      levelSolutions[i] = levelList[i].name.toLowerCase();
      levelInputButtons[i] = levelList[i].inputButtons.toLowerCase();
    }
    maxLevel = levelSolutions.length;
    stageName.value = !(levelSolutions[level.value] == null)
        ? levelSolutions[level.value].toLowerCase()
        : "";
  }

  //resets the old stage data and updates it with new data
  void updateStage() {
    if (level < levelSolutions.length) {
      animationTrigger = 0;
      clearJokerUsed.value = false;
      stageName.value = !(levelSolutions[level.value] == null)
          ? levelSolutions[level.value].toLowerCase()
          : "";
      solutionList = RxList<Button>.empty();
      for (int i = 0; i < stageName.value.length; i++) {
        solutionList.add(Button(
          buttonID: -1,
          solutionID: -1,
          letter: '',
          usedCurrently: false,
          hinted: false,
          clearedByJoker: false,
        ));
      }
      buttonList = RxList<Button>.empty();
      for (int i = 0; i <= 9; i++) {
        buttonList.add(Button(
          buttonID: i,
          solutionID: -1,
          letter: levelInputButtons[level.value][i],
          usedCurrently: false,
          hinted: false,
          clearedByJoker: false,
        ));
      }
    }
  }

  //add correct letter hint function
  void correctLetterHintButton() {
    bool hintFound = false;
    //loop over solution to find first wrong letter
    for (int i = 0; i < solutionList.length; i++) {
      //if correct go to next
      if (solutionList[i].letter == stageName.value[i]) {
      }
      //else handle hint
      else {
        //for buttons in the input buttons
        for (int j = 0; j < buttonList.length; j++) {
          if (!buttonList[j].usedCurrently &&
              !buttonList[j].hinted &&
              !buttonList[j].clearedByJoker &&
              !hintFound) {
            if (buttonList[j].letter == stageName.value[i]) {
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
            if (buttonList[j].letter == stageName.value[i]) {
              //remove button in wrong spot
              if (!(solutionList[i].buttonID == -1)) {
                removeInputButton(solutionList[i].buttonID, i);
              }
              //remove correct button from wrong spot and then add it to the right spot
              buttonList[j] = Button(
                  buttonID: buttonList[j].buttonID,
                  solutionID: buttonList[j].solutionID,
                  letter: buttonList[j].letter,
                  usedCurrently: buttonList[j].usedCurrently,
                  hinted: true,
                  clearedByJoker: buttonList[j].clearedByJoker);

              removeInputButton(j, buttonList[j].solutionID);
              addInputButton(j);
              hintFound = true;
              break;
            }
          }
        }
      }
    }
  }

  //clear wrong letters hint function
  void clearAllWrongButtons() {
    List<int> rightButtons = [];
    //add right buttons to the rightButtons list
    for (int i = 0; i < stageName.value.length; i++) {
      for (int j = 0; j < buttonList.length; j++) {
        if (buttonList[j].letter == stageName.value[i] &&
            !rightButtons.contains(j)) {
          rightButtons.add(j);
          break;
        }
      }
    }
    //remove buttons from the solution if they are not hinted
    for (int i = 0; i < stageName.value.length; i++) {
      if (!(solutionList[i].buttonID == -1) && !solutionList[i].hinted) {
        removeInputButton(solutionList[i].buttonID, i);
      }
    }
    //at the end makes wrong buttons invisible
    for (int i = 0; i < buttonList.length; i++) {
      if (!rightButtons.contains(i)) {
        buttonList[i] = Button(
            buttonID: buttonList[i].buttonID,
            solutionID: buttonList[i].solutionID,
            letter: buttonList[i].letter,
            usedCurrently: true,
            hinted: buttonList[i].hinted,
            clearedByJoker: true);
      }
    }
    clearJokerUsed.value = true;
  }

  //used to reset the animation effect
  void resetAnimationEffect() {
    animationTrigger = -1;
  }

  //removes the input button from the solution
  void removeInputButton(int buttonNumber, int solutionNumber) {
    solutionList[solutionNumber] = Button(
      buttonID: -1,
      solutionID: -1,
      letter: '',
      usedCurrently: false,
      hinted: false,
      clearedByJoker: false,
    );

    buttonList[buttonNumber] = Button(
        buttonID: buttonList[buttonNumber].buttonID,
        solutionID: -1,
        letter: buttonList[buttonNumber].letter,
        usedCurrently: false,
        hinted: buttonList[buttonNumber].hinted,
        clearedByJoker: buttonList[buttonNumber].clearedByJoker);
  }

  //adds the input button to the solution
  void addInputButton(int buttonNumber) {
    int spot = checkAvailableSpot();

    if (spot == -1) {
    } else {
      solutionList[spot] = Button(
        buttonID: buttonList[buttonNumber].buttonID,
        solutionID: spot,
        letter: buttonList[buttonNumber].letter,
        usedCurrently: true,
        hinted: buttonList[buttonNumber].hinted,
        clearedByJoker: buttonList[buttonNumber].clearedByJoker,
      );
      buttonList[buttonNumber] = Button(
          buttonID: buttonList[buttonNumber].buttonID,
          solutionID: spot,
          letter: buttonList[buttonNumber].letter,
          usedCurrently: true,
          hinted: buttonList[buttonNumber].hinted,
          clearedByJoker: buttonList[buttonNumber].clearedByJoker);

      if (listFull()) {
        attemptCheck();
      }
    }
  }

  //checks if the solution is correct
  void attemptCheck() {
    //makes a string out of the solution list for the check
    String attempt = "";
    for (int i = 0; i < stageName.value.length; i++) {
      attempt = attempt + solutionList[i].letter.toLowerCase();
    }
    //checks if the attempt is correct
    if (attempt == stageName.value) {
      //checks if the level is the last level
      if (level.value == levelSolutions.length - 1) {
        moneyController.addCurrency(moneyController.levelClearReward);
        addLevel(1);
        stageName.value = "";
        resetAnimationEffect();
        winScreen = true;
      }
      //if is not the last level
      else if (level.value < levelSolutions.length - 1) {
        moneyController.addCurrency(moneyController.levelClearReward);
        addLevel(1);
        updateStage();
        resetAnimationEffect();
      }
    }
    //play the animation because the attempt is wrong
    else {
      animationTrigger = animationTrigger + 2;
    }
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

  //gets the current level from the box
  int get getCurrentLevelFromBox {
    return box.read(currentLevelName) ?? 0;
  }

  //adds the input to the level in the box
  void addLevel(int input) {
    level.value += input;
    box.write(currentLevelName, level.value);
  }

  //change the level to a certain value in the box
  void changeLevel(int value) {
    level.value = value;
    box.write(currentLevelName, value);
  }

  //delete the level from the box
  void deleteLevel() {
    level.value = 0;
    box.remove(currentLevelName);
  }
}
