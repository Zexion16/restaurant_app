import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CartController extends GetxController {
  final _meal = {}.obs;

  // void addMeal(MenuItem meal, int amount) {
  //   if (_meal.containsKey(meal)) {
  //     _meal[meal] += amount;
  //   } else {
  //     _meal[meal] = amount;
  //     Get.snackbar("Meal Added",
  //         "You have added ${_meal[meal]}x ${meal.title} to the cart",
  //         duration: Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  // fix indexing problem
  void addMealFromDB(QueryDocumentSnapshot data, int amount) {
    var mealEntries = _meal.entries.map((meal) => meal.key['meal']).toList();

    if (mealEntries.contains(data['meal'])) {
      _meal[data] += amount;
    } else {
      _meal[data] = amount;
      Get.snackbar("Meal Added",
          "You have added ${_meal[data]}x ${data['meal']} to the cart",
          duration: Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
    }
  }

  //fixed
  void removeMeal(QueryDocumentSnapshot data, int index) {
    var mealEntries = _meal.entries.map((meal) => meal.key['meal']).toList();

    if (mealEntries.contains(data['meal']) && _meal[data] == 1) {
      _meal.removeWhere((key, value) => key == data);
      Get.snackbar("Meal Removed",
          "You have removed ${mealEntries[index]} from the cart",
          duration: Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
    } else {
      _meal[data] -= 1;
    }
  }

  get meals => _meal;

  get productSupTotal {
    if (_meal.entries.isNotEmpty) {
      return _meal.entries
          .map((meal) => meal.key['price'] * meal.value)
          .toList();
    } else
      return 0;
  }

  get totalPrice {
    if (_meal.entries.isNotEmpty) {
      return _meal.entries
          .map((meal) => meal.key['price'] * meal.value)
          .toList()
          .reduce((value, element) => value + element)
          .toStringAsFixed(2);
    } else {
      return "0";
    }
  }
}
