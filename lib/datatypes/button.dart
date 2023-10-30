//for the button data of the game
class Button {
  //variables
  int id;
  String letter;
  bool usedCurrently;
  bool hinted;

  //constructor
  Button({
    required this.id,
    required this.letter,
    required this.usedCurrently,
    required this.hinted,
  });

  //converts the data to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': letter,
      'usedCurrently': usedCurrently,
      'hinted': hinted,
    };
  }

  //converts the json to data
  static Button fromJson(Map<String, dynamic> json) {
    return Button(
      id: json['id'] as int,
      letter: json['name'] as String,
      usedCurrently: json['usedCurrently'] as bool,
      hinted: json['hinted'] as bool,
    );
  }

  @override
  String toString() {
    return 'Button{id: $id, letter: $letter, usedCurrently: $usedCurrently, hinted: $hinted}';
  }
}
