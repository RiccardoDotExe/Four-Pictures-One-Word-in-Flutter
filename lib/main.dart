import 'package:flutter/material.dart';

//firestore database
import 'package:firebase_core/firebase_core.dart';
import 'package:four_pictures_one_word/data/database_helper.dart';
import 'package:four_pictures_one_word/firebase/firebase_options.dart';

//getx
import 'package:get_storage/get_storage.dart';

//home screen
import 'package:four_pictures_one_word/screens/home_screen.dart';

Future main() async {
  //wait for getxstorage to initialize
  await GetStorage.init();

  //wait for firebase to initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(FourPicturesOneWordApp());
}

class FourPicturesOneWordApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FourPicturesOneWordApp({super.key});

  @override
  State<FourPicturesOneWordApp> createState() => _FourPicturesOneWordAppState();
}

class _FourPicturesOneWordAppState extends State<FourPicturesOneWordApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        //wait for the data to be loaded
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show a loading screen while data is being fetched
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading Screen'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // handle error state
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // data has been loaded
            return MaterialApp(
              home: HomeScreen(),
            );
          }
        },
      ),
    );
  }

  //method to load data from database and shared preference
  Future<void> getData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.loadLevels();
  }
}
