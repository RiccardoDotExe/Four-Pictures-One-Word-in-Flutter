import 'package:flutter/material.dart';
import 'package:four_pictures_one_word/home_screen.dart';

void main() => runApp(const FourPicturesOneWordApp());

class FourPicturesOneWordApp extends StatelessWidget {
  const FourPicturesOneWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
