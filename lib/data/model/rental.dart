class Rental {
  final int id;
  final int userId;
  final int productId;
  final int storeId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final String status;
  final DateTime createdAt;

  Rental({
    required this.id,
    required this.userId,
    required this.productId,
    required this.storeId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      storeId: json['store_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "product_id": productId,
      "store_id": storeId,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "total_price": totalPrice,
      "status": status,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
