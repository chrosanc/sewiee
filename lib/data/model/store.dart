class Store {
  final int id;
  final int ownerId;
  final String storeName;
  final String? description;
  final String? address;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  Store({
    required this.id,
    required this.ownerId,
    required this.storeName,
    required this.status,
    required this.createdAt,
    this.description,
    this.address,
    this.imageUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      ownerId: json['owner_id'],
      storeName: json['store_name'],
      description: json['description'],
      address: json['address'],
      imageUrl: json['image_url'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "owner_id": ownerId,
      "store_name": storeName,
      "description": description,
      "address": address,
      "image_url": imageUrl,
      "status": status,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
