
class ExpeditionModel {
  String id;
  String courierName;

  ExpeditionModel({required this.id, required this.courierName});

  factory ExpeditionModel.fromFirestore(Map<String, dynamic> data) {
    return ExpeditionModel(
      id: data['courier_code'] ?? '',
      courierName: data['courier_name'] ?? ''
    );
  }
}

class VillageModel {
  final String code;

  final String name;

  final String districtCode;
  final String district;

  final String regencyCode;
  final String regency;

  final String provinceCode;
  final String province;

  final List<String> postalCodes;

  const VillageModel({
    required this.code,

    required this.name,

    required this.districtCode,
    required this.district,

    required this.regencyCode,
    required this.regency,

    required this.provinceCode,
    required this.province,

    required this.postalCodes,
  });

  factory VillageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return VillageModel(
      code: json['code'] ?? '',

      name: json['name'] ?? '',

      districtCode:
      json['district_code'] ?? '',

      district:
      json['district'] ?? '',

      regencyCode:
      json['regency_code'] ?? '',

      regency:
      json['regency'] ?? '',

      provinceCode:
      json['province_code'] ?? '',

      province:
      json['province'] ?? '',

      postalCodes: List<String>.from(
        json['postal_codes'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,

      "name": name,

      "district_code": districtCode,
      "district": district,

      "regency_code": regencyCode,
      "regency": regency,

      "province_code": provinceCode,
      "province": province,

      "postal_codes": postalCodes,
    };
  }
}

class ShippingCostModel {

  final String courierCode;

  final String courierName;

  final int price;

  final int weight;

  final String? estimation;

  const ShippingCostModel({
    required this.courierCode,

    required this.courierName,

    required this.price,

    required this.weight,

    required this.estimation,
  });

  factory ShippingCostModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShippingCostModel(
      courierCode:
      json['courier_code'] ?? '',

      courierName:
      json['courier_name'] ?? '',

      price:
      json['price'] ?? 0,

      weight:
      json['weight'] ?? 0,

      estimation:
      json['estimation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courier_code": courierCode,

      "courier_name": courierName,

      "price": price,

      "weight": weight,

      "estimation": estimation,
    };
  }

  ShippingCostModel copyWith({
    String? courierCode,
    String? courierName,
    int? price,
    int? weight,
    String? estimation,
  }) {
    return ShippingCostModel(
      courierCode:
      courierCode ??
          this.courierCode,

      courierName:
      courierName ??
          this.courierName,

      price:
      price ?? this.price,

      weight:
      weight ?? this.weight,

      estimation:
      estimation ??
          this.estimation,
    );
  }
}