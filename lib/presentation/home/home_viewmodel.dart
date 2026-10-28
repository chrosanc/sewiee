import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/data/services/category_service.dart';
import 'package:sewiee/data/services/product_service.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class HomeViewModel extends ChangeNotifier {
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();

  // FIREBASE
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? userProfile;

  // LOADING
  bool isLoading = false;
  void _showLoadingDialog() => _loadingManager.showLoading();
  void _hideLoadingDialog() => _loadingManager.hideLoading();

  // PRODUCT
  final ProductService productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> activeProducts = [];

  // CATEGORY
  final CategoryService categoryService = CategoryService();
  List<CategoryModel> categories = [];


  Future<void> getCategory() async {
    _showLoadingDialog();

    try {
      categories = await categoryService.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }


  Future<void> getAllProducts(context) async{
    _showLoadingDialog();
    try {
      products = await productService.getProducts();
      activeProducts = products.where((product) => product.active && product.stock > 0).toList();
      notifyListeners();

    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }


  Future<void> getUser(BuildContext context) async {
    _showLoadingDialog();

    final String user = _auth.currentUser!.uid;

    try {
      final doc = await _firestore.collection('users').doc(user).get();
      if(doc.exists) {
        userProfile = UserModel.fromJson(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

}