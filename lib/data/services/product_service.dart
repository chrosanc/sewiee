import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sewiee/data/model/product_model.dart';

class ProductService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final String collection = 'products';

  /// CREATE PRODUCT
  Future<void> createProduct(ProductModel product) async {
    await firestore.collection(collection).doc(product.id).set(
      product.toJson(),
    );
  }

  /// GET ALL PRODUCTS
  Future<List<ProductModel>> getProducts() async {
    final result = await firestore
        .collection(collection)
        .orderBy('created_at', descending: true)
        .get();

    return result.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  /// GET PRODUCT DETAIL
  Future<ProductModel?> getProductById(String productId) async {
    final result =
    await firestore.collection(collection).doc(productId).get();

    if (!result.exists) {
      return null;
    }

    return ProductModel.fromJson(result.data()!);
  }

  /// GET PRODUCT BY OWNER
  Future<List<ProductModel>> getProductsByOwner(
      String ownerId,
      ) async {
    final result = await firestore
        .collection(collection)
        .where('owner_id', isEqualTo: ownerId)
        .get();

    return result.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }
  
  /// UPDATE ACTIVATION
  
  Future<void> setActiveProduct(bool isActive, String productId) async {
    await firestore.collection(collection).doc(productId).update(
        {'active': isActive});
  }

  /// 🔥 UPDATE PRODUCT
  Future<void> updateProduct(ProductModel product) async {
    await firestore.collection(collection).doc(product.id).update(
      product.toJson(),
    );
  }

  /// 🔥 DELETE PRODUCT
  Future<void> deleteProduct(String productId) async {
    await firestore.collection(collection).doc(productId).delete();
  }

  Future<void> updateProductImage(String imageUrl) async {
    final ref = storage.refFromURL(imageUrl);
    await ref.delete();
  }

  Future<void> deleteAllImages(String productId) async {
    final folderRef =  storage.ref(collection).child(productId);
    final result = await folderRef.listAll();
    for(final item in result.items) {
      await item.delete();
    }
  }
}