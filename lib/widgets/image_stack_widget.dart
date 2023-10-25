import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageStackWidget extends StatefulWidget {
  String stageName;
  ImageStackWidget({super.key, required this.stageName});
  @override
  State<ImageStackWidget> createState() => _ImageStackWidgetState();
}

class _ImageStackWidgetState extends State<ImageStackWidget> {
  int _stackIndex = 1; //index for the stack of pictures
  String _displayImage =
      "assets/eis0.jpg"; //placeholder for the zoom in picture

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

  //used to generatea the clickable images
  GestureDetector generateClickableImages(int index, String stageName) {
    return GestureDetector(
      onTap: () {
        changeIndex(0);
        changeImage(
            "assets/${stageName.toLowerCase()}$index.jpg"); //for the zoomed in picture
      },
      child: Image.asset("assets/${stageName.toLowerCase()}$index.jpg",
          height: 100, width: 100, fit: BoxFit.fill),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 300.0,
      child: IndexedStack(
        index: _stackIndex,
        children: [
          GestureDetector(
            onTap: () {
              changeIndex(1);
            },
            child: SizedBox(
              width: 300.0,
              height: 300.0,
              child: Image.asset(
                _displayImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              generateClickableImages(0, widget.stageName),
              generateClickableImages(1, widget.stageName),
              generateClickableImages(2, widget.stageName),
              generateClickableImages(3, widget.stageName)
            ],
          ),
        ],
      ),
    );
  }
}