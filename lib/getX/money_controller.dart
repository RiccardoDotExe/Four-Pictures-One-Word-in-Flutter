import 'package:flutter/material.dart';

//getx
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//custom widgets
import 'package:four_pictures_one_word/widgets/money_tapper_widget.dart';

class MoneyController extends GetxController {
  final box = GetStorage();

  //name of the saved box variable
  static const String currentCurrencyName = "currentCurrency";

  //money data
  var money = 100.obs;

  int levelClearReward = 30;
  int correctLetterCost = 10;
  int clearWrongLetterCost = 20;

  //initialize money
  @override
  void onInit() {
    super.onInit();
    money.value = getCurrentCurrencyFromBox;
  }

  //get current currency from box
  int get getCurrentCurrencyFromBox {
    return box.read(currentCurrencyName) ?? 100;
  }

  //add given money to the current money and save it in box
  void addCurrency(int input) {
    money.value += input;
    box.write(currentCurrencyName, money.value);
  }

  //change current currency and money to the given value and save it in box
  void changeCurrency(int value) {
    money.value = value;
    box.write(currentCurrencyName, value);
  }

  //resets money and deletes current currency from box
  void deleteCurrency() {
    money.value = 0;
    box.remove(currentCurrencyName);
  }

  //money buy screen
  Future moneyScreen(BuildContext context) {
    final controller = Get.put(MoneyController());
    return showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: false,
        builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You got ${controller.money} coins! Get more:"),
                ],
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * .7,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  //list of offers
                  children: [
                    MoneyTapperWidget(moneyValue: 10),
                    MoneyTapperWidget(moneyValue: 25),
                    MoneyTapperWidget(moneyValue: 50),
                    MoneyTapperWidget(moneyValue: 100)
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); //out of game screen
                        },
                        child: const Text("go back")),
                  ],
                )
              ],
            ));
  }
}
