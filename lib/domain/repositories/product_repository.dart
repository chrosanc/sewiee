import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/services/product_service.dart';

class ProductRepository {

  final productService = ProductService();

  /// CREATE PRODUCT
  Future<void> createProduct(ProductModel product) async {
    try {
      await productService.createProduct(product);
    } catch (e) {
      rethrow;
    }
  }

  /// GET ALL PRODUCTS
  Future<List<ProductModel>> getProducts() async {
    try {
      return await productService.getProducts();
    } catch (e) {
      rethrow;
    }
  }

  /// GET PRODUCT DETAIL
  Future<ProductModel?> getProductById(
      String productId,
      ) async {
    try {
      return await productService.getProductById(productId);
    } catch (e) {
      rethrow;
    }
  }

  /// GET PRODUCTS BY OWNER
  Future<List<ProductModel>> getProductsByOwner(
      String ownerId,
      ) async {
    try {
      return await productService.getProductsByOwner(ownerId);
    } catch (e) {
      rethrow;
    }
  }

  /// SET PRODUCT ACTIVE
  Future<void> setProductActive(bool isActive, String productId) async {
    try{
      await productService.setActiveProduct(isActive, productId);
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE PRODUCT
  Future<void> updateProduct(ProductModel product) async {
    try {
      await productService.updateProduct(product);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE PRODUCT
  Future<void> deleteProduct(String productId) async {
    try {
      await productService.deleteProduct(productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProductImage(String imageUrl) async {
    try {
      await productService.updateProductImage(imageUrl);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllImages(String productId) async {
    try {
      await productService.deleteAllImages(productId);
    } catch (e) {
      rethrow;
    }
  }
}