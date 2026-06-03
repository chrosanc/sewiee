class PaymentMethodModel {
  final String id;

  final String name;

  final String provider;

  final String type;

  final String image;

  final bool active;

  PaymentMethodModel({
    required this.id,

    required this.name,

    required this.provider,

    required this.type,

    required this.image,

    required this.active,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',

      name: json['name'] ?? '',

      provider: json['provider'] ?? '',

      type: json['type'] ?? '',

      image: json['image'] ?? '',

      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "name": name,

      "provider": provider,

      "type": type,

      "image": image,

      "active": active,
    };
  }
}

class TransactionModel {
  // =========================
  // ORDER
  // =========================

  final String orderDocId;

  final String orderNumber;

  final int grossAmount;

  // =========================
  // PAYMENT
  // =========================

  final PaymentMethodModel paymentMethod;

  // =========================
  // CUSTOMER
  // =========================

  final MidtransCustomer customer;

  // =========================
  // ITEM
  // =========================

  final List<MidtransItemDetail> itemDetails;

  const TransactionModel({
    required this.orderDocId,

    required this.orderNumber,

    required this.grossAmount,

    required this.paymentMethod,

    required this.customer,

    required this.itemDetails,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      orderDocId: json['orderDocId'] ?? '',

      orderNumber: json['orderNumber'] ?? '',

      grossAmount: json['grossAmount'] ?? 0,

      paymentMethod: PaymentMethodModel.fromJson(json['paymentMethod'] ?? {}),

      customer: MidtransCustomer.fromJson(json['customer'] ?? {}),

      itemDetails: (json['itemDetails'] as List<dynamic>? ?? [])
          .map((e) => MidtransItemDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderDocId,

      "orderNumber": orderNumber,

      "grossAmount": grossAmount,

      "paymentMethod": paymentMethod.toJson(),

      "customer": customer.toJson(),

      "itemDetails": itemDetails.map((e) => e.toJson()).toList(),
    };
  }
}

// =========================
// CUSTOMER
// =========================

class MidtransCustomer {
  final String name;

  final String email;

  final String phone;

  final MidtransShippingAddress shippingAddress;

  const MidtransCustomer({
    required this.name,

    required this.email,

    required this.phone,
    required this.shippingAddress,
  });

  factory MidtransCustomer.fromJson(Map<String, dynamic> json) {
    return MidtransCustomer(
      name: json['name'] ?? '',

      email: json['email'] ?? '',

      phone: json['phone'] ?? '',

      shippingAddress: MidtransShippingAddress.fromJson(json['shippingAddress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      'shippingAddress': shippingAddress.toJson()
    };
  }
}

class MidtransShippingAddress {
  final String firstName;
  final String fullAddress;

  MidtransShippingAddress({
    required this.firstName,
    required this.fullAddress,
  });

  factory MidtransShippingAddress.fromJson(Map<String, dynamic> json) {
    return MidtransShippingAddress(
      firstName: json['firstName'] ?? '',
      fullAddress: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'address': fullAddress,
    };
  }
}

// =========================
// ITEM DETAIL
// =========================

class MidtransItemDetail {
  final String id;

  final int price;

  final int quantity;

  final String name;

  const MidtransItemDetail({
    required this.id,

    required this.price,

    required this.quantity,

    required this.name,
  });

  factory MidtransItemDetail.fromJson(Map<String, dynamic> json) {
    return MidtransItemDetail(
      id: json['id'] ?? '',

      price: json['price'] ?? 0,

      quantity: json['quantity'] ?? 1,

      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "price": price, "quantity": quantity, "name": name};
  }
}

class MidtransTransactionResponseModel {
  final bool success;

  final String? message;

  final MidtransPaymentData? data;

  const MidtransTransactionResponseModel({
    required this.success,

    this.message,

    this.data,
  });

  factory MidtransTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return MidtransTransactionResponseModel(
      success: json['success'] ?? false,

      message: json['message'],

      data: json['data'] != null
          ? MidtransPaymentData.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
    );
  }
}

class MidtransPaymentData {
  final String transactionId;

  final String orderId;

  final String transactionStatus;

  final String paymentType;

  final String? expiryTime;

  final List<VANumberModel> vaNumbers;

  final String? qrString;

  final String? redirectUrl;

  const MidtransPaymentData({
    required this.transactionId,

    required this.orderId,

    required this.transactionStatus,

    required this.paymentType,

    this.expiryTime,

    required this.vaNumbers,

    this.qrString,

    this.redirectUrl,
  });

  factory MidtransPaymentData.fromJson(Map<String, dynamic> json) {
    return MidtransPaymentData(
      transactionId: json['transaction_id'] ?? '',

      orderId: json['order_id'] ?? '',

      transactionStatus: json['transaction_status'] ?? '',

      paymentType: json['payment_type'] ?? '',

      expiryTime: json['expiry_time'],

      qrString: json['qr_string'],

      redirectUrl: json['redirect_url'],

      vaNumbers: (json['va_numbers'] as List<dynamic>? ?? [])
          .map((e) => VANumberModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class VANumberModel {
  final String bank;

  final String vaNumber;

  const VANumberModel({required this.bank, required this.vaNumber});

  factory VANumberModel.fromJson(Map<String, dynamic> json) {
    return VANumberModel(
      bank: json['bank'] ?? '',

      vaNumber: json['va_number'] ?? '',
    );
  }
}
