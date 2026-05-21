import 'package:flutter/material.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/domain/repositories/category_repository.dart';

class ExploreViewmodel extends ChangeNotifier {

  List<CategoryModel> categories = [];
  final CategoryRepository _repository = CategoryRepository();
  bool isLoading = false;

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _repository.fetchCategories();

    } catch (e) {
      debugPrint("Error : $e");
    }

    isLoading = false;
    notifyListeners();
  }

}