import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/money_controller.dart';

AppBar buildCustomAppBar(BuildContext context, Widget title) {
  final moneyController = Get.put(MoneyController());
  return AppBar(
    title: title,
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          moneyController.moneyScreen(context);
        },
        child: Row(
          children: [
            const Icon(Icons.money),
            const SizedBox(width: 5),
            Center(child: (Obx(() => Text("${moneyController.money}")))),
          ],
        ),
      ),
      Container(width: 25),
    ],
  );
}
