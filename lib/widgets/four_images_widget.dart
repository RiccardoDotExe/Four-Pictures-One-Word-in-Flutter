import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/level_controller.dart';

// ignore: must_be_immutable
class FourImagesWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FourImagesWidget({super.key});
  @override
  State<FourImagesWidget> createState() => _FourImagesWidgetState();
}

class _FourImagesWidgetState extends State<FourImagesWidget> {
  final levelController = Get.put(LevelController());

  //used to generate the clickable images
  Container generateImages(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Obx(() => !(levelController.stageName.value == "")
          ? Image.asset(
              "assets/${levelController.stageName.value.toLowerCase()}$index.jpg",
              fit: BoxFit.fill,
            )
          : Image.asset(
              "assets/work_in_progress.jpg",
              fit: BoxFit.fill,
            )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 300.0,
      //indexed stack switches between one big picture and grid of pictures
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: <Widget>[
          generateImages(0),
          generateImages(1),
          generateImages(2),
          generateImages(3)
        ],
      ),
    );
  }
}
