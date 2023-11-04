import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

// ignore: must_be_immutable
class ImageStackWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ImageStackWidget({super.key});
  @override
  State<ImageStackWidget> createState() => _ImageStackWidgetState();
}

class _ImageStackWidgetState extends State<ImageStackWidget> {
  final levelController = Get.put(LevelController());
  int _stackIndex = 1; //index for the stack of pictures
  String _displayImage =
      "assets/work_in_progress.jpg"; //placeholder for the zoom in picture

  //method to change from zoom in and out picture
  void changeIndex(int newIndex) {
    setState(() {
      _stackIndex = newIndex;
    });
  }

  //method to change the zoomed in picture
  void changeImage(String newString) {
    setState(() {
      _displayImage = newString;
    });
  }

  //used to generate the clickable images
  GestureDetector generateClickableImages(int index) {
    return GestureDetector(
      onTap: () {
        changeIndex(0);
        changeImage(
            "assets/${levelController.stageName.toLowerCase()}$index.jpg"); //for the zoomed in picture
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: Colors.blue),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Obx(
          () => !(levelController.stageName.value == "")
              ? Image.asset(
                  "assets/${levelController.stageName.value.toLowerCase()}$index.jpg",
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  "assets/work_in_progress.jpg",
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 300.0,
      //indexed stack switches between one big picture and grid of pictures
      child: IndexedStack(
        index: _stackIndex,
        children: [
          //zoomed in picture
          GestureDetector(
            onTap: () {
              changeIndex(1);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                _displayImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          //grid of pictures
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: <Widget>[
              generateClickableImages(0),
              generateClickableImages(1),
              generateClickableImages(2),
              generateClickableImages(3)
            ],
          ),
        ],
      ),
    );
  }
}
