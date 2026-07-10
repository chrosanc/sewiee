import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/data/model/expedition_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/category_repository.dart';
import 'package:sewiee/domain/repositories/expedition_repository.dart';
import 'package:sewiee/domain/repositories/product_repository.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class AddProductViewmodel extends ChangeNotifier {
  // =========================
  // REPOSITORIES
  // =========================

  final CategoryRepository categoryRepository = CategoryRepository();

  final ProductRepository productRepository = ProductRepository();

  final UserRepository userRepository = UserRepository();

  final ExpeditionRepository expeditionRepository = ExpeditionRepository();

  // =========================
  // STATE
  // =========================

  bool isLoading = false;

  // =========================
  // USER
  // =========================

  UserModel? userModel;

  // =========================
  // ADDRESS
  // =========================

  AddressModel? selectedAddress;

  // =========================
  // CATEGORY
  // =========================

  List<CategoryModel> categories = [];

  CategoryModel? selectedCategory;

  // =========================
  // PRODUCT IMAGES
  // =========================

  List<File> productPhotos = [];

  // =========================
  // RENT DURATION
  // =========================

  final List<String> rentDurations = ['Hari', 'Bulan'];

  String? selectedDuration;

  // =========================
  // DELIVERY METHODS
  // =========================

  final Set<String> selectedDeliveryMethods = {};

  // pickup
  // seller_delivery
  // expedition

  // =========================
  // RETURN METHODS
  // =========================

  final Set<String> selectedReturnMethods = {};

  // self_return
  // seller_pickup
  // expedition_return

  // =========================
  // EXPEDITIONS
  // =========================

  List<ExpeditionModel> expeditions = [];

  final Set<String> selectedExpeditions = {};

  // =========================
  // RENTAL TERMS
  // =========================

  bool requireIdentity = false;

  bool requireDeposit = false;

  bool cancellationAllowed = false;

  // =========================
  // GETTERS
  // =========================

  bool get hasDeliveryMethod => selectedDeliveryMethods.isNotEmpty;

  bool get hasReturnMethod => selectedReturnMethods.isNotEmpty;

  String get deliveryMethodLabel {
    if (selectedDeliveryMethods.isEmpty) {
      return 'Pilih Metode Pengiriman';
    }

    List<String> labels = [];

    if (selectedDeliveryMethods.contains('pickup')) {
      labels.add('Ambil Sendiri');
    }

    if (selectedDeliveryMethods.contains('seller_delivery')) {
      labels.add('Diambil Penjual');
    }

    if (selectedDeliveryMethods.contains('expedition')) {
      labels.add('Ekspedisi');
    }

    return labels.join(', ');
  }

  String get returnMethodLabel {
    if (selectedReturnMethods.isEmpty) {
      return 'Pilih Metode Pengembalian';
    }

    List<String> labels = [];

    if (selectedReturnMethods.contains('self_return')) {
      labels.add('Kembalikan Sendiri');
    }

    if (selectedReturnMethods.contains('seller_pickup')) {
      labels.add('Diambil Penjual');
    }

    if (selectedReturnMethods.contains('expedition_return')) {
      labels.add('Ekspedisi');
    }

    return labels.join(', ');
  }

  // =========================
  // SETTERS
  // =========================

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSelectedAddress(AddressModel address) {
    selectedAddress = address;
    notifyListeners();
  }

  void setSelectedCategory(CategoryModel? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSelectedDuration(String? value) {
    selectedDuration = value;
    notifyListeners();
  }

  void setRequireIdentity(bool value) {
    requireIdentity = value;
    notifyListeners();
  }

  void setRequireDeposit(bool value) {
    requireDeposit = value;
    notifyListeners();
  }

  void setCancellationAllowed(bool value) {
    cancellationAllowed = value;
    notifyListeners();
  }

  // =========================
  // DELIVERY METHODS
  // =========================

  void toggleDeliveryMethod(String method) {
    if (selectedDeliveryMethods.contains(method)) {
      selectedDeliveryMethods.remove(method);
    } else {
      selectedDeliveryMethods.add(method);
    }

    notifyListeners();
  }

  // =========================
  // RETURN METHODS
  // =========================

  void toggleReturnMethod(String method) {
    if (selectedReturnMethods.contains(method)) {
      selectedReturnMethods.remove(method);
    } else {
      selectedReturnMethods.add(method);
    }

    notifyListeners();
  }

  // =========================
  // EXPEDITIONS
  // =========================

  Future<void> loadExpeditions(BuildContext context) async {
    setLoading(true);

    try {
      expeditions = await expeditionRepository.getAllExpeditions();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  void toggleExpedition(String expeditionId) {
    if (selectedExpeditions.contains(expeditionId)) {
      selectedExpeditions.remove(expeditionId);
    } else {
      selectedExpeditions.add(expeditionId);
    }

    notifyListeners();
  }

  // =========================
  // LOAD CATEGORY
  // =========================

  Future<void> loadCategories() async {
    setLoading(true);

    try {
      categories = await categoryRepository.fetchCategories();
    } catch (e) {
      debugPrint('Load Category Error : $e');
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // USER
  // =========================

  Future<void> getCurrentUser(BuildContext context) async {
    setLoading(true);

    try {
      userModel = await userRepository.getCurrentUser();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // PICK PRODUCT PHOTO
  // =========================

  Future<void> pickProductPhotos() async {
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

  // =========================
  // REMOVE PRODUCT PHOTO
  // =========================

  void removePhoto(int index) {
    productPhotos.removeAt(index);
    notifyListeners();
  }

  // =========================
  // VALIDATION
  // =========================

  String? validateForm({
    required String productName,

    required String description,

    required String price,

    required String stock,

    required String depositAmount,

    required String additionalNotes,
    required String expeditionWeights,
    required Set<String> expeditions,
  }) {
    if (productName.trim().isEmpty) {
      return 'Nama produk wajib diisi';
    }

    if (description.trim().isEmpty) {
      return 'Deskripsi wajib diisi';
    }

    if (price.trim().isEmpty) {
      return 'Harga wajib diisi';
    }

    if (stock.trim().isEmpty) {
      return 'Stock wajib diisi';
    }

    if (selectedCategory == null) {
      return 'Kategori wajib dipilih';
    }

    if (selectedDuration == null) {
      return 'Durasi sewa wajib dipilih';
    }

    if (selectedAddress == null) {
      return 'Alamat wajib dipilih';
    }

    if (productPhotos.isEmpty) {
      return 'Foto produk wajib ditambahkan';
    }

    if (!hasDeliveryMethod) {
      return 'Metode pengiriman wajib dipilih';
    }

    if (!hasReturnMethod) {
      return 'Metode pengembalian wajib dipilih';
    }

    if (requireDeposit && depositAmount.trim().isEmpty) {
      return 'Deposit wajib diisi';
    }

    if (selectedDeliveryMethods.contains('expedition')) {
      if (expeditionWeights.trim().isEmpty) {
        return 'Berat barang wajib diisi';
      }

      if (selectedExpeditions.isEmpty) {
        return 'Kurir ekspedisi wajib dipilih';
      }
    }

    return null;
  }

  // =========================
  // UPLOAD IMAGES
  // =========================

  Future<List<String>> uploadProductImages(String productId) async {
    List<String> imageUrls = [];

    for (final image in productPhotos) {
      final fileName = '${const Uuid().v4()}.jpg';

      final ref = FirebaseStorage.instance
          .ref()
          .child('products')
          .child(productId)
          .child(fileName);

      final uploadTask = await ref.putFile(image);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  // =========================
  // CREATE PRODUCT
  // =========================

  Future<String?> createProduct({
    required BuildContext context,

    required TextEditingController productNameController,

    required TextEditingController descriptionController,

    required TextEditingController priceController,

    required TextEditingController stockController,

    required TextEditingController depositController,

    required TextEditingController additionalNotesController,

    required TextEditingController expeditionWeightController,
  }) async {
    final validationMessage = validateForm(
      productName: productNameController.text,

      description: descriptionController.text,

      price: priceController.text,

      stock: stockController.text,

      depositAmount: depositController.text,

      additionalNotes: additionalNotesController.text,
      expeditionWeights: expeditionWeightController.text.trim(),
      expeditions: selectedExpeditions,
    );

    if (validationMessage != null) {
      return validationMessage;
    }

    setLoading(true);

    try {
      final productId = const Uuid().v4();

      // =========================
      // UPLOAD IMAGES
      // =========================

      final imageUrls = await uploadProductImages(productId);

      // =========================
      // BUILD MODEL
      // =========================

      final product = ProductModel(
        id: productId,

        ownerId: userModel!.uid,

        ownerName: userModel!.username,

        storeName: userModel!.storeName,

        storeUsername: userModel!.storeUsername,

        phoneNumber: userModel!.phoneNumber,

        productName: productNameController.text.trim(),

        description: descriptionController.text.trim(),

        categoryId: selectedCategory!.id,

        categoryName: selectedCategory!.name,

        price: int.parse(priceController.text.replaceAll('.', '')),

        durationType: selectedDuration!,

        stock: int.parse(stockController.text),

        active: true,

        images: imageUrls,

        address: selectedAddress!,

        // =========================
        // DELIVERY
        // =========================
        deliveryOptions: DeliveryOptionsModel(
          pickup: PickupDeliveryModel(
            enabled: selectedDeliveryMethods.contains('pickup'),

            label: 'Ambil Sendiri',
          ),

          sellerDelivery: SellerDeliveryModel(
            enabled: selectedDeliveryMethods.contains('seller_delivery'),
          ),

          expedition: ExpeditionDeliveryModel(
            enabled: selectedDeliveryMethods.contains('expedition'),

            weight: int.tryParse(expeditionWeightController.text) ?? 0,

            couriers: selectedExpeditions.toList(),
          ),
        ),

        // =========================
        // RETURN OPTIONS
        // =========================
        returnOptions: ReturnOptions(
          selfReturn: SelfReturnOption(
            enabled: selectedReturnMethods.contains('self_return'),

            label: 'Kembalikan Sendiri',
          ),

          sellerPickup: SellerPickupOption(
            enabled: selectedReturnMethods.contains('seller_pickup'),
          ),

          expeditionReturn: ExpeditionReturnOption(
            enabled: selectedReturnMethods.contains('expedition_return'),
          ),
        ),

        // =========================
        // RENTAL TERMS
        // =========================
        rentalTerms: RentalTerms(
          requireIdentity: requireIdentity,

          requireDeposit: requireDeposit,

          depositAmount: requireDeposit
              ? int.parse(depositController.text.replaceAll('.', ''))
              : 0,

          cancellationAllowed: cancellationAllowed,

          additionalNotes: additionalNotesController.text.trim(),
        ),

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );

      // =========================
      // SAVE FIRESTORE
      // =========================

      await productRepository.createProduct(product);
      resetForm();
      return null;
    } catch (e) {
      debugPrint('Create Product Error : $e');

      return 'Gagal menambahkan produk';
    } finally {
      setLoading(false);
    }
  }

  // =========================
  // RESET FORM
  // =========================

  void resetForm() {
    selectedAddress = null;

    selectedCategory = null;

    selectedDuration = null;

    selectedDeliveryMethods.clear();

    selectedReturnMethods.clear();

    selectedExpeditions.clear();

    requireIdentity = false;

    requireDeposit = false;

    cancellationAllowed = false;

    productPhotos.clear();

    selectedExpeditions.clear();

    notifyListeners();
  }
}
