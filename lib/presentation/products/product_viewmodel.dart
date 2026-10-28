import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/services/product_service.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductViewmodel extends ChangeNotifier {
  // PRODUCT
  final ProductService productService = ProductService();
  ProductModel? product;

  /// =========================
  /// LOADING VARIABLE
  /// =========================
  bool isLoading = false;
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();
  void _showLoadingDialog() => _loadingManager.showLoading();
  void _hideLoadingDialog() => _loadingManager.hideLoading();

  void setProductModel(ProductModel model){
    product = model;
    notifyListeners();
  }

  Future<void> getDetailedProduct (BuildContext context, String productId) async {
    isLoading = true;
    _showLoadingDialog();
    notifyListeners();

    try {
      product = await productService.getProductById(productId);
      notifyListeners();
    } catch(e) {
      Toast().showToast(context, e.toString());
    }finally {
      isLoading =false;
      _hideLoadingDialog();
      notifyListeners();
    }
  }

  Future<void> openGoogleMaps(BuildContext context) async {
    final latitude = product!.address.latitude;
    final longitude = product!.address.longitude;

    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if(await canLaunchUrl(url)) {

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    } else {
      Toast().showToast(context, 'Tidak dapat membuka Google Maps');
      throw 'Tidak dapat membuka Google Maps';

    }

  }

}