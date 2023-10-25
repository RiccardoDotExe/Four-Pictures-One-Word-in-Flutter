import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/home_screen.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';
import 'package:four_pictures_one_word/sharedpreferences/shared_preference_helper.dart';
import 'package:provider/provider.dart';

void main() => runApp(FourPicturesOneWordApp());

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
      providers: [
        ChangeNotifierProvider<LevelProvider>(
          create: (context) => LevelProvider(),
        ),
      ],
      child: MaterialApp(
          home: FutureBuilder(
        future: _sharedPreferenceHelper.getCurrentLevelFromSharedPreference,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading screen while data is being fetched
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading Screen'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle error state
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Data has been loaded, show the main screen
            int currentLevel = snapshot.data as int;
            return HomeScreen(initialLevel: currentLevel);
          }
        },
      )),
    );
  }
}
