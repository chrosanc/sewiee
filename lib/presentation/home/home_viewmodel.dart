import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/data/services/category_service.dart';
import 'package:sewiee/data/services/product_service.dart';

class HomeViewModel extends ChangeNotifier{

  // FIREBASE
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? userProfile;

  // BOOL
  bool isLoading = false;


  // PRODUCT
  final ProductService productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> activeProducts = [];

  // CATEGORY
  final CategoryService categoryService = CategoryService();
  List<CategoryModel> categories = [];


  Future<void> getCategory() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await categoryService.getCategories();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getAllProducts(context) async{
    isLoading = true;
    notifyListeners();
    try {
      products = await productService.getProducts();
      activeProducts = products.where((product) => product.active).toList();
      notifyListeners();

    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final String user = _auth.currentUser!.uid;

    try {
      final doc = await _firestore.collection('users').doc(user).get();
      if(doc.exists) {
        userProfile = UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}