class UserModel {
  // =========================
  // BASIC USER INFO
  // =========================

  final String uid;
  final String fullName;
  final String username;

  final String email;
  final String phoneNumber;

  final String? profileImage;
  final String? bio;

  // =========================
  // STORE INFO
  // =========================

  final String storeName;
  final String storeUsername;

  // final String? storeImage;
  // final String? storeDescription;

  // =========================
  // STORE SETTINGS
  // =========================

  // final bool allowPickup;
  // final bool allowSellerDelivery;
  // final bool allowExpedition;
  //
  // final int sellerDeliveryFee;

  // =========================
  // STATS
  // =========================

  final int totalProducts;
  final int totalTransactions;

  final double storeRating;

  // =========================
  // META
  // =========================

  final bool isVerified;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,

    this.profileImage,
    this.bio,

    required this.storeName,
    required this.storeUsername,

    // this.storeImage,
    // this.storeDescription,

    // this.allowPickup = true,
    // this.allowSellerDelivery = true,
    // this.allowExpedition = false,
    //
    // this.sellerDeliveryFee = 0,

    this.totalProducts = 0,
    this.totalTransactions = 0,
    this.storeRating = 0,

    this.isVerified = false,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',

      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',

      email: json['email'] ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',

      profileImage: json['profile_image'],
      bio: json['bio'],

      storeName: json['store_name'] ?? '',
      storeUsername: json['store_username'] ?? '',

      // storeImage: json['store_image'],
      // storeDescription: json['store_description'],

      // allowPickup: json['allow_pickup'] ?? true,
      // allowSellerDelivery:
      // json['allow_seller_delivery'] ?? true,
      // allowExpedition: json['allow_expedition'] ?? false,
      //
      // sellerDeliveryFee:
      // json['seller_delivery_fee'] ?? 0,

      totalProducts: json['total_products'] ?? 0,
      totalTransactions:
      json['total_transactions'] ?? 0,

      storeRating:
      (json['store_rating'] ?? 0).toDouble(),

      isVerified: json['is_verified'] ?? false,
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,

      "full_name": fullName,
      "username": username,

      "email": email,
      "phone_number": phoneNumber,

      "profile_image": profileImage,
      "bio": bio,

      "store_name": storeName,
      "store_username": storeUsername,

      // "store_image": storeImage,
      // "store_description": storeDescription,

      // "allow_pickup": allowPickup,
      // "allow_seller_delivery": allowSellerDelivery,
      // "allow_expedition": allowExpedition,

      // "seller_delivery_fee": sellerDeliveryFee,

      "total_products": totalProducts,
      "total_transactions": totalTransactions,

      "store_rating": storeRating,

      "is_verified": isVerified,
      "fcm_token": fcmToken,
    };
  }
}