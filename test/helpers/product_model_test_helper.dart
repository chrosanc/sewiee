import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/product_model.dart';

/// Helper factory for creating ProductModel instances in tests with sensible defaults
class ProductModelTestHelper {
  /// Creates a ProductModel with default test values
  /// All parameters are optional and can be overridden
  static ProductModel createTestProduct({
    String id = '1',
    String ownerId = 'owner1',
    String ownerName = 'Test Owner',
    String storeName = 'Test Store',
    String storeUsername = 'test_store',
    String phoneNumber = '08123456789',
    String productName = 'Test Product',
    String description = 'Test Description',
    String categoryId = 'cat1',
    String categoryName = 'Test Category',
    int price = 50000,
    String durationType = 'day',
    int stock = 10,
    bool active = true,
    List<String>? images,
    AddressModel? address,
    DeliveryOptionsModel? deliveryOptions,
    ReturnOptions? returnOptions,
    RentalTerms? rentalTerms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id,
      ownerId: ownerId,
      ownerName: ownerName,
      storeName: storeName,
      storeUsername: storeUsername,
      phoneNumber: phoneNumber,
      productName: productName,
      description: description,
      categoryId: categoryId,
      categoryName: categoryName,
      price: price,
      durationType: durationType,
      stock: stock,
      active: active,
      images: images ?? [],
      address: address ?? _createTestAddress(),
      deliveryOptions: deliveryOptions ?? _createTestDeliveryOptions(),
      returnOptions: returnOptions ?? _createTestReturnOptions(),
      rentalTerms: rentalTerms ?? _createTestRentalTerms(),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static AddressModel _createTestAddress() {
    return AddressModel();
  }

  static DeliveryOptionsModel _createTestDeliveryOptions() {
    return DeliveryOptionsModel(
      pickup: PickupDeliveryModel(enabled: false, label: 'Ambil Sendiri'),
      sellerDelivery: SellerDeliveryModel(enabled: false),
      expedition: ExpeditionDeliveryModel(
        enabled: true,
        weight: 1000,
        couriers: [],
      ),
    );
  }

  static ReturnOptions _createTestReturnOptions() {
    return ReturnOptions(
      selfReturn: SelfReturnOption(enabled: true, label: 'Kembalikan Sendiri'),
      sellerPickup: SellerPickupOption(enabled: true),
      expeditionReturn: ExpeditionReturnOption(enabled: true),
    );
  }

  static RentalTerms _createTestRentalTerms() {
    return RentalTerms(
      requireIdentity: true,
      requireDeposit: true,
      depositAmount: 0,
      cancellationAllowed: true,
      additionalNotes: '',
    );
  }
}
