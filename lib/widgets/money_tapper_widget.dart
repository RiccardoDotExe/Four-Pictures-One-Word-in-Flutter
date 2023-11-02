import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';

//custom getx controller
import 'package:four_pictures_one_word/getX/money_controller.dart';

// ignore: must_be_immutable
class MoneyTapperWidget extends StatefulWidget {
  final int moneyValue;

  // ignore: prefer_const_constructors_in_immutables
  MoneyTapperWidget({
    super.key,
    required this.moneyValue,
  });

  @override
  State<MoneyTapperWidget> createState() => _MoneyTapperWidgetState();
}

class _MoneyTapperWidgetState extends State<MoneyTapperWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MoneyController());

    return GestureDetector(
      onTap: () {
        controller.addCurrency(widget.moneyValue);
        Navigator.pop(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.width * .3,
        width: MediaQuery.of(context).size.width * .3,
        color: Colors.blue,
        child: Center(child: Text("+${widget.moneyValue} Coins")),
      ),
    );
  }
}
