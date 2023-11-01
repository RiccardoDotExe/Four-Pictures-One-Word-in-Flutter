import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:four_pictures_one_word/provider/level_provider.dart';

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
    LevelProvider levelProvider = Provider.of<LevelProvider>(context);
    return GestureDetector(
      onTap: () {
        levelProvider
            .updateMoney(levelProvider.getCurrentMoney + widget.moneyValue);
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
