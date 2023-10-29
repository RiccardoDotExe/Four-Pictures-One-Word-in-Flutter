//for the level data of the game
class Level {
  //variables
  final int id;
  final String name;
  final String inputButtons;

  //constructor
  Level({
    required this.id,
    required this.name,
    required this.inputButtons,
  });

  //converts the data to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inputButtons': inputButtons,
    };
  }

  //converts the json to data
  static Level fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as int,
      name: json['name'] as String,
      inputButtons: json['inputButtons'] as String,
    );
  }

  @override
  String toString() {
    return 'Level{id: $id, name: $name, inputButtons: $inputButtons}';
  }
}
