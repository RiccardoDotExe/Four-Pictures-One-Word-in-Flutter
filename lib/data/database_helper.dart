//level datatype
import 'package:four_pictures_one_word/datatypes/level.dart';

//firestore database
import 'package:cloud_firestore/cloud_firestore.dart';

//helper class for database
class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //levels to be loaded from database
  List<Level> levels = [];

  //get the levels
  Future<List<Level>> get getLevels async {
    return levels;
  }

  //constructor
  DatabaseHelper();

  //load levels from database
  Future loadLevels() async {
    await _firestore.collection('level').get().then((snapshot) => {
          // ignore: avoid_function_literals_in_foreach_calls
          snapshot.docs.forEach((document) {
            Level newLevel = Level.fromJson(document.data());
            levels.add(newLevel);
          })
        });
    //for debugging
    /*
    for (int i = 0; i < items.length; i++) {
      print(items[i].toString());
    }
    print(items.length);
    */
  }
}
