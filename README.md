# Four Pictures One Word in Flutter

A recreation of the app "four pictures one word" in flutter using Cloud Firestore for backend storage, Flutter Animate for animating effects, GetX for state management and GetXStorage for backing up data on the device. This project is a smaller-scale version of the before mentioned popular game, which allows users to guess the word based on the four pictures provided.

## Screens and Features

- **Home Screen:** The home screen gives the user a preview of the current level, a play button and a button to reset the entire game.
\
![Screenshot of Home Screen](/screenshots/home_screen.jpg)

- **Four Pictures One Word:** In the game screen the user is presented with four picture which represent the word the user is trying to guess.
\
![Screenshot of Game Screen](/screenshots/game_screen.jpg)

- **Wrong Solution Animation:** The red shake effect plays when the attempt the user made is wrong.
\
![Wrong Animation Gif](/screenshots/wrong_animation.gif)

- **Add Correct Letter Hint:** The button with the lightbulb icon checks the solution and adds the correct unremovable button at the first wrong/empty letter to the solution.
\
![Screenshot of Correct Letter Hint](/screenshots/correct_letter_hint.jpg)

- **Clear Wrong Letters Hint:** The button with the trashcan icon removes all letters that are not needed for the solution.
\
![Screenshot of Clear Wrong Letters Hint](/screenshots/clear_wrong_hint.jpg)

- **Buy Menu:** Currently just lets you choose the amount of currency you want and adds it to your balance.
\
![Screenshot of Buy Menu](/screenshots/buy_menu.jpg)

- **Win Screen:** Shows work in progress pictures in preview and congratulates you for clearing all levels when you try to press play.
\
![Screenshot of Win Screen](/screenshots/win_screen.jpg)

## Playthrough

You can find a video of playthrough of the game here: [Playthrough](/screenshots/playthrough.mp4)

## Technologies and Packages

- [Cloud Firestore](https://pub.dev/packages/cloud_firestore): a scalable NoSQL cloud database from Firebase and Google Cloud Platform.
- [GetX](https://pub.dev/packages/get): a great package for state management, route managemenent and dependency injection
- [GetX Storage](https://pub.dev/packages/get_storage): a package to back up data with key-value in the memory
- [Flutter Animate](https://pub.dev/packages/flutter_animate): a package for animating the effects
