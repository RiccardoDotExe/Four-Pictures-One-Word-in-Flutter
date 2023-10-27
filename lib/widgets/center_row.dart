import 'package:flutter/material.dart';

//just a simple row that is centered and takes in a list of widgets
class CustomCenterRow extends StatelessWidget {
  final List<Widget> widgets;

  // ignore: prefer_const_constructors_in_immutables
  CustomCenterRow({
    super.key,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    //row scales with screen width
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgets),
      ),
    );
  }
}
