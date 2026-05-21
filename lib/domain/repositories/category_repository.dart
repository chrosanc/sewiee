import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _service = CategoryService();

  Future<List<CategoryModel>> fetchCategories() {
    return _service.getCategories();
  }
 }