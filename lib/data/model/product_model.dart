import 'package:sewiee/data/model/address_model.dart';

class ProductModel {
  // =========================
  // BASIC
  // =========================

  final String id;

  final String ownerId;
  final String ownerName;

  final String storeName;
  final String storeUsername;
  final String phoneNumber;

  final String productName;
  final String description;

  final String categoryId;
  final String categoryName;

  final int price;

  /// day / week / month
  final String durationType;

  final int stock;

  /// active / inactive
  final bool active;

  final List<String> images;

  // =========================
  // LOCATION
  // =========================

  final AddressModel address;

  // =========================
  // DELIVERY OPTIONS
  // =========================

  final DeliveryOptionsModel deliveryOptions;

  // =========================
  // RETURN OPTIONS
  // =========================

  final ReturnOptions returnOptions;

  // =========================
  // RENTAL TERMS
  // =========================

  final RentalTerms rentalTerms;

  // =========================
  // DATE
  // =========================

  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,

    required this.ownerId,
    required this.ownerName,

    required this.storeName,
    required this.storeUsername,
    required this.phoneNumber,

    required this.productName,
    required this.description,

    required this.categoryId,
    required this.categoryName,

    required this.price,
    required this.durationType,

    required this.stock,
    required this.active,

    required this.images,

    required this.address,

    required this.deliveryOptions,
    required this.returnOptions,

    required this.rentalTerms,

    required this.createdAt,
    required this.updatedAt,
  });

  // =========================
  // FROM JSON
  // =========================

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',

      ownerId: json['owner_id'] ?? '',
      ownerName: json['owner_name'] ?? '',

      storeName: json['store_name'] ?? '',
      storeUsername: json['store_username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',

      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',

      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',

      price: json['price'] ?? 0,

      durationType: json['duration_type'] ?? '',

      stock: json['stock'] ?? 0,

      active: json['active'] ?? true,

      images: List<String>.from(json['images'] ?? []),

      address: AddressModel.fromMap(json['address'] ?? {}),

      deliveryOptions: DeliveryOptionsModel.fromJson(json['delivery_options'] ?? {}),

      returnOptions: ReturnOptions.fromJson(json['return_options'] ?? {}),

      rentalTerms: RentalTerms.fromJson(json['rental_terms'] ?? {}),

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),

      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // =========================
  // TO JSON
  // =========================

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "owner_id": ownerId,
      "owner_name": ownerName,

      "store_name": storeName,
      "store_username": storeUsername,
      "phone_number": phoneNumber,

      "product_name": productName,
      "description": description,

      "category_id": categoryId,
      "category_name": categoryName,

      "price": price,
      "duration_type": durationType,

      "stock": stock,
      "active": active,

      "images": images,

      "address": address.toMap(),

      "delivery_options": deliveryOptions.toJson(),

      "return_options": returnOptions.toJson(),

      "rental_terms": rentalTerms.toJson(),

      "created_at": createdAt.toIso8601String(),

      "updated_at": updatedAt.toIso8601String(),
    };
  }

  // =========================
  // COPY WITH
  // =========================

  ProductModel copyWith({
    String? id,

    String? ownerId,
    String? ownerName,

    String? storeName,
    String? storeUsername,
    String? phoneNumber,

    String? productName,
    String? description,

    String? categoryId,
    String? categoryName,

    int? price,
    String? durationType,

    int? stock,
    bool? active,

    List<String>? images,

    AddressModel? address,

    DeliveryOptionsModel? deliveryOptions,
    ReturnOptions? returnOptions,

    RentalTerms? rentalTerms,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,

      ownerId: ownerId ?? this.ownerId,

      ownerName: ownerName ?? this.ownerName,

      storeName: storeName ?? this.storeName,
      storeUsername: storeUsername ?? this.storeUsername,
      phoneNumber: phoneNumber ?? this.phoneNumber,

      productName: productName ?? this.productName,

      description: description ?? this.description,

      categoryId: categoryId ?? this.categoryId,

      categoryName: categoryName ?? this.categoryName,

      price: price ?? this.price,

      durationType: durationType ?? this.durationType,

      stock: stock ?? this.stock,

      active: active ?? this.active,

      images: images ?? this.images,

      address: address ?? this.address,

      deliveryOptions: deliveryOptions ?? this.deliveryOptions,

      returnOptions: returnOptions ?? this.returnOptions,

      rentalTerms: rentalTerms ?? this.rentalTerms,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// =========================
// DELIVERY OPTIONS
// =========================

class DeliveryOptionsModel {

  final PickupDeliveryModel pickup;

  final SellerDeliveryModel sellerDelivery;

  final ExpeditionDeliveryModel expedition;

  const DeliveryOptionsModel({
    required this.pickup,
    required this.sellerDelivery,
    required this.expedition,
  });

  factory DeliveryOptionsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryOptionsModel(
      pickup: PickupDeliveryModel.fromJson(
        json['pickup'] ?? {},
      ),

      sellerDelivery:
      SellerDeliveryModel.fromJson(
        json['seller_delivery'] ?? {},
      ),

      expedition:
      ExpeditionDeliveryModel.fromJson(
        json['expedition'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pickup": pickup.toJson(),

      "seller_delivery":
      sellerDelivery.toJson(),

      "expedition":
      expedition.toJson(),
    };
  }

  DeliveryOptionsModel copyWith({
    PickupDeliveryModel? pickup,
    SellerDeliveryModel? sellerDelivery,
    ExpeditionDeliveryModel? expedition,
  }) {
    return DeliveryOptionsModel(
      pickup: pickup ?? this.pickup,

      sellerDelivery:
      sellerDelivery ??
          this.sellerDelivery,

      expedition:
      expedition ?? this.expedition,
    );
  }
}

// =========================
// PICKUP DELIVERY
// =========================

class PickupDeliveryModel {

  final bool enabled;

  final String label;

  const PickupDeliveryModel({
    required this.enabled,
    required this.label,
  });

  factory PickupDeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PickupDeliveryModel(
      enabled:
      json['enabled'] ?? false,

      label:
      json['label'] ??
          'Ambil Sendiri',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "enabled": enabled,
      "label": label,
    };
  }

  PickupDeliveryModel copyWith({
    bool? enabled,
    String? label,
  }) {
    return PickupDeliveryModel(
      enabled:
      enabled ?? this.enabled,

      label:
      label ?? this.label,
    );
  }
}

// =========================
// SELLER DELIVERY
// =========================

class SellerDeliveryModel {

  final bool enabled;

  // final int fee;
  //
  // final String note;
  //
  // final int maxDistanceKm;

  const SellerDeliveryModel({
    required this.enabled,
    // required this.fee,
    // required this.note,
    // required this.maxDistanceKm,
  });

  factory SellerDeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SellerDeliveryModel(
      enabled:
      json['enabled'] ?? false,

      // fee:
      // json['fee'] ?? 0,
      //
      // note:
      // json['note'] ?? '',
      //
      // maxDistanceKm:
      // json['max_distance_km'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "enabled": enabled,

      // "fee": fee,
      //
      // "note": note,
      //
      // "max_distance_km":
      // maxDistanceKm,
    };
  }

  SellerDeliveryModel copyWith({
    bool? enabled,
    int? fee,
    String? note,
    int? maxDistanceKm,
  }) {
    return SellerDeliveryModel(
      enabled:
      enabled ?? this.enabled,

      // fee:
      // fee ?? this.fee,
      //
      // note:
      // note ?? this.note,
      //
      // maxDistanceKm:
      // maxDistanceKm ??
      //     this.maxDistanceKm,
    );
  }
}

// =========================
// EXPEDITION
// =========================

class ExpeditionDeliveryModel {

  final bool enabled;

  /// gram
  final int weight;

  final List<String> couriers;

  const ExpeditionDeliveryModel({
    required this.enabled,
    required this.weight,
    required this.couriers,
  });

  factory ExpeditionDeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpeditionDeliveryModel(
      enabled:
      json['enabled'] ?? false,

      weight:
      json['weight'] ?? 0,

      couriers:
      List<String>.from(
        json['couriers'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "enabled": enabled,
      "weight": weight,
      "couriers": couriers,
    };
  }

  ExpeditionDeliveryModel copyWith({
    bool? enabled,
    int? weight,
    List<String>? couriers,
  }) {
    return ExpeditionDeliveryModel(
      enabled:
      enabled ?? this.enabled,

      weight:
      weight ?? this.weight,

      couriers:
      couriers ?? this.couriers,
    );
  }
}

// =========================
// RETURN OPTIONS
// =========================

class ReturnOptions {
  final SelfReturnOption selfReturn;

  final SellerPickupOption sellerPickup;

  final ExpeditionReturnOption expeditionReturn;

  const ReturnOptions({
    required this.selfReturn,
    required this.sellerPickup,
    required this.expeditionReturn,
  });

  factory ReturnOptions.fromJson(Map<String, dynamic> json) {
    return ReturnOptions(
      selfReturn: SelfReturnOption.fromJson(json['self_return'] ?? {}),

      sellerPickup: SellerPickupOption.fromJson(json['seller_pickup'] ?? {}),

      expeditionReturn: ExpeditionReturnOption.fromJson(
        json['expedition_return'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "self_return": selfReturn.toJson(),

      "seller_pickup": sellerPickup.toJson(),

      "expedition_return": expeditionReturn.toJson(),
    };
  }
}

// =========================
// SELF RETURN OPTION
// =========================

class SelfReturnOption {
  final bool enabled;
  final String label;

  const SelfReturnOption({required this.enabled, required this.label});

  factory SelfReturnOption.fromJson(Map<String, dynamic> json) {
    return SelfReturnOption(
      enabled: json['enabled'] ?? false,

      label: json['label'] ?? 'Kembalikan Sendiri',
    );
  }

  Map<String, dynamic> toJson() {
    return {"enabled": enabled, "label": label};
  }
}

// =========================
// SELLER PICKUP OPTION
// =========================

class SellerPickupOption {
  final bool enabled;

  // final int fee;
  // final String note;

  const SellerPickupOption({
    required this.enabled,
    // required this.fee,
    // required this.note,
  });

  factory SellerPickupOption.fromJson(Map<String, dynamic> json) {
    return SellerPickupOption(
      enabled: json['enabled'] ?? false,

      // fee: json['fee'] ?? 0,
      //
      // note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"enabled": enabled};
  }
}

// =========================
// EXPEDITION RETURN OPTION
// =========================

class ExpeditionReturnOption {
  final bool enabled;

  const ExpeditionReturnOption({required this.enabled});

  factory ExpeditionReturnOption.fromJson(Map<String, dynamic> json) {
    return ExpeditionReturnOption(
      enabled: json['enabled'] ?? false,

    );
  }

  Map<String, dynamic> toJson() {
    return {"enabled": enabled};
  }
}

// =========================
// RENTAL TERMS
// =========================

class RentalTerms {
  final bool requireIdentity;

  final bool requireDeposit;

  final int depositAmount;

  final bool cancellationAllowed;

  final String additionalNotes;

  const RentalTerms({
    required this.requireIdentity,

    required this.requireDeposit,

    required this.depositAmount,

    required this.cancellationAllowed,

    required this.additionalNotes,
  });

  factory RentalTerms.fromJson(Map<String, dynamic> json) {
    return RentalTerms(
      requireIdentity: json['require_identity'] ?? false,

      requireDeposit: json['require_deposit'] ?? false,

      depositAmount: json['deposit_amount'] ?? 0,

      cancellationAllowed: json['cancellation_allowed'] ?? false,

      additionalNotes: json['additional_notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "require_identity": requireIdentity,

      "require_deposit": requireDeposit,

      "deposit_amount": depositAmount,

      "cancellation_allowed": cancellationAllowed,

      "additional_notes": additionalNotes,
    };
  }
}
