import 'package:flutter/material.dart';

//used for level data on device
import 'package:four_pictures_one_word/sharedpreferences/shared_preference_helper.dart';

//firestore database
import 'package:firebase_core/firebase_core.dart';
import 'package:four_pictures_one_word/firebase/firebase_options.dart';

//used for state management
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

//home screen
import 'package:four_pictures_one_word/screens/home_screen.dart';

Future main() async {
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
  final SharedPreferenceHelper _sharedPreferenceHelper =
      SharedPreferenceHelper();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //one provider for now but we can add more later
      providers: [
        ChangeNotifierProvider<LevelProvider>(
          create: (context) => LevelProvider(),
        ),
      ],
      child: MaterialApp(
          home: FutureBuilder(
        //wait for the data to be loaded from shared preferences
        future: _sharedPreferenceHelper.getCurrentLevelFromSharedPreference,
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
            // data has been loaded, show the main screen
            int currentLevel = snapshot.data as int;
            return HomeScreen(initialLevel: currentLevel);
          }
        },
      )),
    );
  }
}
