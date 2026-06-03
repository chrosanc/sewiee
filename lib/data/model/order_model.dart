import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';

class OrderModel {
  // =========================
  // BASIC
  // =========================

  final String id;
  final String orderNumber;

  // =========================
  // USER
  // =========================

  final String renterId;
  final String ownerId;

  final UserSnapshot renterSnapshot;
  final UserSnapshot ownerSnapshot;

  // =========================
  // PRODUCT SNAPSHOT
  // =========================

  final ProductSnapshot productSnapshot;

  // =========================
  // ADDRESS
  // =========================
  final Address address;

  // =========================
  // RENTAL
  // =========================

  final RentalDetail rental;

  // =========================
  // SHIPPING
  // =========================

  final ShippingDetail shipping;

  // =========================
  // PAYMENT
  // =========================

  final PaymentDetail payment;

  // =========================
  // RETURN
  // =========================

  // final ReturnDetail returnDetail;

  // =========================
  // STATUS
  // =========================

  final OrderStatus status;

  // =========================
  // DATE
  // =========================

  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,

    required this.renterId,
    required this.ownerId,

    required this.renterSnapshot,
    required this.ownerSnapshot,

    required this.productSnapshot,

    required this.address,

    required this.rental,

    required this.shipping,

    required this.payment,

    // required this.returnDetail,
    required this.status,

    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',

      orderNumber: json['order_number'] ?? '',

      renterId: json['renter_id'] ?? '',

      ownerId: json['owner_id'] ?? '',

      renterSnapshot: UserSnapshot.fromJson(json['renter_snapshot'] ?? {}),

      ownerSnapshot: UserSnapshot.fromJson(json['owner_snapshot'] ?? {}),

      productSnapshot: ProductSnapshot.fromJson(json['product_snapshot'] ?? {}),

      address: Address.fromJson(json['address'] ?? {}),

      rental: RentalDetail.fromJson(json['rental'] ?? {}),

      shipping: ShippingDetail.fromJson(json['shipping'] ?? {}),

      payment: PaymentDetail.fromJson(json['payment'] ?? {}),

      // returnDetail: ReturnDetail.fromJson(json['return_detail'] ?? {}),
      status: OrderStatusX.fromString(json['status'] ?? 'waiting_payment'),

      createdAt:
          DateFormat.parseFirestoreDate(json['created_at']) ?? DateTime.now(),

      updatedAt:
          DateFormat.parseFirestoreDate(json['updated_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "order_number": orderNumber,

      "renter_id": renterId,

      "owner_id": ownerId,

      "renter_snapshot": renterSnapshot.toJson(),

      "owner_snapshot": ownerSnapshot.toJson(),

      "product_snapshot": productSnapshot.toJson(),

      "address": address.toJson(),

      "rental": rental.toJson(),

      "shipping": shipping.toJson(),

      "payment": payment.toJson(),

      // "return_detail": returnDetail.toJson(),
      "status": status.value,

      "created_at": createdAt,

      "updated_at": updatedAt,
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,

    String? renterId,
    String? ownerId,

    UserSnapshot? renterSnapshot,
    UserSnapshot? ownerSnapshot,

    ProductSnapshot? productSnapshot,

    Address? address,

    RentalDetail? rental,

    ShippingDetail? shipping,

    PaymentDetail? payment,

    OrderStatus? status,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,

      orderNumber: orderNumber ?? this.orderNumber,

      renterId: renterId ?? this.renterId,

      ownerId: ownerId ?? this.ownerId,

      renterSnapshot: renterSnapshot ?? this.renterSnapshot,

      ownerSnapshot: ownerSnapshot ?? this.ownerSnapshot,

      productSnapshot: productSnapshot ?? this.productSnapshot,

      address: address ?? this.address,

      rental: rental ?? this.rental,

      shipping: shipping ?? this.shipping,

      payment: payment ?? this.payment,

      status: status ?? this.status,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// =========================
// USER SNAPSHOT
// =========================

class UserSnapshot {
  final String id;
  final String name;
  final String username;

  const UserSnapshot({
    required this.id,
    required this.name,
    required this.username,
  });

  factory UserSnapshot.fromJson(Map<String, dynamic> json) {
    return UserSnapshot(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "username": username};
  }
}

// =========================
// ADDRESS
// =========================
class Address {
  final AddressModel renter;
  final AddressModel store;

  Address({required this.renter, required this.store});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      renter: AddressModel.fromMap(json['renter']),
      store: AddressModel.fromMap(json['store']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'renter': renter.toMap(), 'store': store.toMap()};
  }
}

// =========================
// PRODUCT SNAPSHOT
// =========================

class ProductSnapshot {
  final String id;

  final String name;

  final String image;

  final int price;

  final String durationType;

  const ProductSnapshot({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.durationType,
  });

  factory ProductSnapshot.fromJson(Map<String, dynamic> json) {
    return ProductSnapshot(
      id: json['id'] ?? '',

      name: json['name'] ?? '',

      image: json['image'] ?? '',

      price: json['price'] ?? 0,

      durationType: json['duration_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "name": name,

      "image": image,

      "price": price,

      "duration_type": durationType,
    };
  }
}

// =========================
// RENTAL
// =========================

class RentalDetail {
  final DateTime? startDate;
  final DateTime? endDate;
  final int lateFee;
  final bool isLate;
  final int? brokenFine;

  final int totalDuration;

  const RentalDetail({
    required this.lateFee,
    required this.isLate,
    this.startDate,
    this.endDate,
    required this.totalDuration, this.brokenFine,
  });

  factory RentalDetail.fromJson(Map<String, dynamic> json) {
    return RentalDetail(
      startDate: DateFormat.parseFirestoreDate(json['start_date']),

      endDate: DateFormat.parseFirestoreDate(json['end_date']),

      lateFee: json['late_fee'] ?? 0,

      isLate: json['is_late'] ?? false,

      brokenFine: json['broken_fine'] ?? 0,

      totalDuration: json['total_duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start_date": startDate,

      "end_date": endDate,

      "late_fee": lateFee,

      "is_late": isLate,

      "broken_fine" : brokenFine,

      "total_duration": totalDuration,
    };
  }

  RentalDetail copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? lateFee,
    bool? isLate,
    int? totalDuration,
  }) {
    return RentalDetail(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lateFee: lateFee ?? this.lateFee,
      isLate: isLate ?? this.isLate,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

// =========================
// SHIPPING
// =========================

class ShippingDetail {
  final String deliveryMethod;

  final String returnMethod;

  final DeliveryTracking? deliveryTracking;

  final ReturnTracking? returnTracking;

  const ShippingDetail({
    required this.deliveryMethod,

    required this.returnMethod,

    this.deliveryTracking,
    this.returnTracking,
  });

  factory ShippingDetail.fromJson(Map<String, dynamic> json) {
    return ShippingDetail(
      deliveryMethod: json['delivery_method'] ?? '',

      returnMethod: json['return_method'] ?? '',

      deliveryTracking: json['delivery_tracking'] != null
          ? DeliveryTracking.fromJson(json['delivery_tracking'])
          : null,

      returnTracking: json['return_tracking'] != null
          ? ReturnTracking.fromJson(json['return_tracking'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "delivery_method": deliveryMethod,

      "return_method": returnMethod,

      "delivery_tracking": deliveryTracking?.toJson(),

      "return_tracking": returnTracking?.toJson(),
    };
  }

  ShippingDetail copyWith({
    String? deliveryMethod,
    String? returnMethod,
    DeliveryTracking? deliveryTracking,
    ReturnTracking? returnTracking,
  }) {
    return ShippingDetail(
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      returnMethod: returnMethod ?? this.returnMethod,
      deliveryTracking: deliveryTracking ?? this.deliveryTracking,
      returnTracking: returnTracking ?? this.returnTracking,
    );
  }
}

// =========================
// PAYMENT
// =========================

class PaymentDetail {
  final PaymentMethodModel paymentMethod;

  final String paymentStatus;

  final String transactionId;

  final Amount amount;

  final DateTime? paidAt;

  final DateTime? expiredAt;

  const PaymentDetail({
    required this.paymentMethod,

    required this.paymentStatus,

    required this.transactionId,

    required this.amount,

    this.paidAt,

    this.expiredAt,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      paymentMethod: PaymentMethodModel.fromJson(json['payment_method']),

      paymentStatus: json['payment_status'] ?? '',

      transactionId: json['transaction_id'] ?? '',

      amount: Amount.fromJson(json['amount'] ?? {}),

      paidAt: DateFormat.parseFirestoreDate(json['paid_at']),

      expiredAt: DateFormat.parseFirestoreDate(json['expired_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "payment_method": paymentMethod.toJson(),

      "payment_status": paymentStatus,

      "transaction_id": transactionId,

      'amount': amount.toJson(),

      "paid_at": paidAt,

      "expired_at": expiredAt,
    };
  }
}

class Amount {
  final int productPrice;

  final int deliveryFee;

  final int depositAmount;

  final int applicationFee;

  final int serviceFee;

  final int totalPayment;

  Amount({
    required this.productPrice,
    required this.deliveryFee,
    required this.depositAmount,
    required this.applicationFee,
    required this.serviceFee,
    required this.totalPayment,
  });

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      productPrice: json['product_price'] ?? 0,

      deliveryFee: json['delivery_fee'] ?? 0,

      depositAmount: json['deposit_amount'] ?? 0,

      applicationFee: json['application_fee'] ?? 0,

      serviceFee: json['service_fee'] ?? 0,

      totalPayment: json['total_payment'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_price": productPrice,

      "delivery_fee": deliveryFee,

      "deposit_amount": depositAmount,

      "application_fee": applicationFee,

      "service_fee": serviceFee,

      "total_payment": totalPayment,
    };
  }
}

// =========================
// RETURN DETAIL
// =========================
//FITUR LANJUTAN

// class ReturnDetail {
//   final bool isReturned;
//
//   final DateTime? returnedAt;
//
//   final String note;
//
//   const ReturnDetail({
//     required this.isReturned,
//
//     this.returnedAt,
//
//     required this.note,
//   });

//   factory ReturnDetail.fromJson(Map<String, dynamic> json) {
//     return ReturnDetail(
//       isReturned: json['is_returned'] ?? false,
//
//       returnedAt: json['returned_at'] != null
//           ? DateTime.tryParse(json['returned_at'])
//           : null,
//
//       note: json['note'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "is_returned": isReturned,
//
//       "returned_at": returnedAt?.toIso8601String(),
//
//       "note": note,
//     };
//   }
// }

class DeliveryTracking {
  final String? courierCode;

  final String? courierName;

  final String? receiptNumber;

  final String? status;

  final DateTime? shippedAt;

  final DateTime? deliveredAt;

  final String? estimation;

  const DeliveryTracking({
    this.courierCode,
    this.courierName,
    this.receiptNumber,
    this.status,
    this.shippedAt,
    this.deliveredAt,
    this.estimation,
  });

  factory DeliveryTracking.fromJson(Map<String, dynamic> json) {
    return DeliveryTracking(
      courierCode: json['courier_code'] ?? '',
      courierName: json['courier_name'] ?? '',
      receiptNumber: json['receipt_number'] ?? '',
      status: json['status'] ?? '',
      shippedAt: DateFormat.parseFirestoreDate(json['shipped_at']),
      deliveredAt: DateFormat.parseFirestoreDate(json['delivered_at']),
      estimation: json['estimation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courier_code": courierCode,
      "courier_name": courierName,
      "receipt_number": receiptNumber,
      "status": status,
      "shipped_at": shippedAt,
      "delivered_at": deliveredAt,
      "estimation": estimation,
    };
  }

  DeliveryTracking copyWith({
    String? courierCode,
    String? courierName,
    String? receiptNumber,
    String? status,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    String? estimation,
  }) {
    return DeliveryTracking(
      courierCode: courierCode ?? this.courierCode,
      courierName: courierName ?? this.courierName,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      status: status ?? this.status,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      estimation: estimation ?? this.estimation,
    );
  }
}

class ReturnTracking {
  final String courierCode;

  final String courierName;

  final String? receiptNumber;

  final String status;

  final DateTime? shippedAt;

  final DateTime? deliveredAt;

  final String? estimation;

  const ReturnTracking({
    required this.courierCode,
    required this.courierName,
    this.receiptNumber,
    required this.status,
    this.shippedAt,
    this.deliveredAt,
    this.estimation,
  });

  factory ReturnTracking.fromJson(Map<String, dynamic> json) {
    return ReturnTracking(
      courierCode: json['courier_code'] ?? '',
      courierName: json['courier_name'] ?? '',
      receiptNumber: json['receipt_number'] ?? '',
      status: json['status'] ?? '',
      shippedAt: DateFormat.parseFirestoreDate(json['shipped_at']),
      deliveredAt: DateFormat.parseFirestoreDate(json['delivered_at']),
      estimation: json['estimation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courier_code": courierCode,
      "courier_name": courierName,
      "receipt_number": receiptNumber,
      "status": status,
      "shipped_at": shippedAt,
      "delivered_at": deliveredAt,
      "estimation": estimation,
    };
  }

  ReturnTracking copyWith({
    String? courierCode,
    String? courierName,
    String? receiptNumber,
    String? status,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    String? estimation,
  }) {
    return ReturnTracking(
      courierCode: courierCode ?? this.courierCode,
      courierName: courierName ?? this.courierName,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      status: status ?? this.status,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      estimation: estimation ?? this.estimation,
    );
  }
}
