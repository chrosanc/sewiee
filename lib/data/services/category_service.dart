import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sewiee/data/model/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      return CategoryModel.fromFirestore(doc.id, doc.data());
    }).toList();
  }

}