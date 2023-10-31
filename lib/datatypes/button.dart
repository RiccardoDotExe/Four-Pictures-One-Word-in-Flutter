//for the button data of the game
class Button {
  //variables
  int buttonID;
  int solutionID;
  String letter;
  bool usedCurrently;
  bool hinted;
  bool clearedByJoker;

  //constructor
  Button({
    required this.buttonID,
    required this.solutionID,
    required this.letter,
    required this.usedCurrently,
    required this.hinted,
    required this.clearedByJoker,
  });

  //converts the data to json
  Map<String, dynamic> toJson() {
    return {
      'buttonID': buttonID,
      'solutionID': solutionID,
      'name': letter,
      'usedCurrently': usedCurrently,
      'hinted': hinted,
      'clearedByJoker': clearedByJoker,
    };
  }

  //converts the json to data
  static Button fromJson(Map<String, dynamic> json) {
    return Button(
      buttonID: json['id'] as int,
      solutionID: json['solutionID'] as int,
      letter: json['name'] as String,
      usedCurrently: json['usedCurrently'] as bool,
      hinted: json['hinted'] as bool,
      clearedByJoker: json['clearedByJoker'] as bool,
    );
  }

  @override
  String toString() {
    return 'Button{buttonID: $buttonID,  solutionID: $solutionID, letter: $letter, usedCurrently: $usedCurrently, hinted: $hinted, clearedByJoker: $clearedByJoker}';
  }
}
