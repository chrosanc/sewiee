import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/category_repository.dart';
import 'package:sewiee/domain/repositories/product_repository.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class ManageMerchantViewmodel extends ChangeNotifier {
  // =========================
  // USER DATA
  // =========================
  UserModel? userModel;
  UserRepository userRepository = UserRepository();

  // =========================
  // PRODUCT DATA
  // =========================

  // CATEGORY DATA
  CategoryRepository categoryRepository = CategoryRepository();
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  // RENT DURATION
  List<String> rentDurationType = ['Hari', 'Bulan'];
  String? selectedDurationType;

  // Product data
  List<ProductModel> listProduct = [];
  ProductModel? productModel;
  ProductRepository productRepository = ProductRepository();

  // Product Photo
  List<dynamic> productPhotos = [];
  List<String> deletedPhotos = [];

  // Terms
  bool identityRequired = false;
  bool depositRequired = false;
  bool fineRequired = false;

  // =========================
  // ODER DATA
  // =========================

  // BELOM ADA

  /// =========================
  /// LOADING VARIABLE
  /// =========================
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();
  void _showLoadingDialog() => _loadingManager.showLoading();
  void _hideLoadingDialog() => _loadingManager.hideLoading();

  // =========================
  // USER FUNCTION
  // =========================
  Future<void> getUser(BuildContext context) async {
    _showLoadingDialog();
    try {
      userModel = await userRepository.getCurrentUser();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  void setUser(UserModel user) {
    userModel = user;
    notifyListeners();
  }

  // =========================
  // PRODUCT FUNCTION
  // =========================

  // PHOTOS FUNCTION

  Future<void> pickProductPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();

      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        productPhotos.addAll(images.map((e) => File(e.path)));

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Pick Image Error : $e');
    }
  }

  void removePhoto(int index) {
    final photo = productPhotos[index];
    if(photo is String) {
      deletedPhotos.add(photo);
    }

    productPhotos.removeAt(index);
    notifyListeners();
  }

  // GET PRODUCT FUNCTION

  Future<void> getCategories(BuildContext context) async{
    _showLoadingDialog();

    try {
      categories = await categoryRepository.fetchCategories();
    } catch(e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> getProductByCurrentUser(BuildContext context) async {
    _showLoadingDialog();

    try {
      if (userModel != null) {
        listProduct = await productRepository.getProductsByOwner(
          userModel!.uid,
        );
        notifyListeners();
      }
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  void setProduct(BuildContext context, ProductModel product) {
    productModel = product;
    notifyListeners();
  }

  void syncProduct (ProductModel product) {
    productModel = product;
    final index = listProduct.indexWhere(
          (e) => e.id == product.id,
    );

    if(index != -1) {
      listProduct[index] = product;
    }

    notifyListeners();
  }

  Future<void> refreshProduct(BuildContext context) async {
    _showLoadingDialog();

    try {
      productModel = await productRepository.getProductById(productModel!.id);
      notifyListeners();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally{
      _hideLoadingDialog();
    }
  }

  // SET PRODUCT FUNCTION
  Future<bool> setProductActive(BuildContext context) async {
    _showLoadingDialog();

    final newStatus = !productModel!.active;

    try{
      await productRepository.setProductActive(newStatus, productModel!.id);
      productModel = productModel!.copyWith(
        active: newStatus
      );

      notifyListeners();
      return true;
    } catch (e) {
      Toast().showToast(context, e.toString());
      return false;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<bool> deleteProduct(BuildContext context) async {
    _showLoadingDialog();
    try {
      await productRepository.deleteAllImages(productModel!.id);
      await productRepository.deleteProduct(productModel!.id);
      Toast().showToast(context, 'Produk berhasil dihapus');
      return true;
    } catch (e) {
      Toast().showToast(context, e.toString());
      return false;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<bool> updateProduct(
      BuildContext context,

      TextEditingController productNameController,
      TextEditingController descriptionController,
      TextEditingController priceController,
      TextEditingController stockController,
      TextEditingController locationController,
      TextEditingController rentRuleController,
      TextEditingController depositController,
      TextEditingController fineController,
      ) async {

    if(productModel == null) return false;

    _showLoadingDialog();

    try {

      final updatedProduct = productModel!.copyWith(

        productName: productNameController.text,
        description: descriptionController.text,

        price: int.parse(priceController.text),
        stock: int.parse(stockController.text),

        durationType: selectedDurationType,

        categoryId: selectedCategory?.id,
        categoryName: selectedCategory?.name,

        updatedAt: DateTime.now(),
      );

      for(final photoUrl in deletedPhotos) {
        await productRepository.updateProductImage(photoUrl);
      }

      await productRepository.updateProduct(updatedProduct);

      syncProduct(updatedProduct);
      notifyListeners();

      Toast().showToast(
        context,
        'Produk berhasil diubah',
      );

      return true;
      // int count = 0;
      //
      // Navigator.of(context).popUntil(
      //       (_) => count++ >= 2,
      // );

    } catch (e) {

      Toast().showToast(
        context,
        e.toString(),
      );
      return false;
    } finally {

      _hideLoadingDialog();

    }
  }

  // SETTER DATA

  void setSelectedDuration(String? value) {
    selectedDurationType = value;
    notifyListeners();
  }

  void setSelectedFine(bool? value) {
    fineRequired = value ?? false;
    notifyListeners();
  }

  void setSelectedidentity(bool? value) {
    identityRequired = value ?? false;
    notifyListeners();
  }

  void setSelectedDeposit(bool? value) {
    depositRequired = value ?? false;
    notifyListeners();
  }


  void setSelectedCategory(CategoryModel? value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> initializeEditProduct(
      BuildContext context,

      TextEditingController productNameController,
      TextEditingController descriptionController,
      TextEditingController priceController,
      TextEditingController locationController,
      TextEditingController stockController,
      TextEditingController rentRuleController,
      TextEditingController fineController,
      TextEditingController depositController,
      ) async {

    _showLoadingDialog();

    try {

      await getCategories(context);

      await setProductData(
        context,
        productNameController,
        descriptionController,
        priceController,
        locationController,
        stockController,
        rentRuleController,
        fineController,
        depositController,
      );

    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> setProductData(BuildContext context,
      TextEditingController productNameController,
      TextEditingController descriptionController,
      TextEditingController priceController,
      TextEditingController locationController,
      TextEditingController stockController,
      TextEditingController rentRuleController,
      TextEditingController fineController,
      TextEditingController depositController,) async {

    if(productModel == null) return;

    productNameController.text = productModel!.productName;
    descriptionController.text = productModel!.description;
    priceController.text = productModel!.price.toString();
    locationController.text = productModel!.address.fullAddress!;
    stockController.text = productModel!.stock.toString();
    // rentRuleController.text = productModel!.rentalTerms.additionalNotes;
    // fineController.text = productModel!.rentalTerms..toString();
    depositController.text = productModel!.rentalTerms.depositAmount.toString();
    selectedCategory = categories.firstWhere((e) => e.id == productModel!.categoryId);
    productPhotos = List.from(productModel!.images);
    identityRequired = productModel!.rentalTerms.requireIdentity;
    depositRequired = productModel!.rentalTerms.requireDeposit;
    fineRequired = productModel!.rentalTerms.cancellationAllowed;
    selectedDurationType = rentDurationType.firstWhere(
          (e) => e == productModel!.durationType,
    );

    notifyListeners();


  }
}
