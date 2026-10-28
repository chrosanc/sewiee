class AddressModel {
  /// =========================
  /// ADDRESS VARIABLE
  /// =========================

  final String? id;

  final String? contactName;
  final String? contactPhoneNumber;

  final String? courierMessage;
  final String? label;

  final double? latitude;
  final double? longitude;

  final String? street;
  final String? province;
  final String? regency;
  final String? district;
  final String? village;
  final String? postCode;

  final String? fullAddress;

  const AddressModel({
    this.id,
    this.contactName,
    this.contactPhoneNumber,
    this.courierMessage,
    this.label,
    this.latitude,
    this.longitude,
    this.street,
    this.province,
    this.regency,
    this.district,
    this.village,
    this.postCode,
    this.fullAddress,
  });

  /// =========================
  /// FROM FIRESTORE MAP
  /// =========================

  factory AddressModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return AddressModel(
      id: map['id'] as String?,

      contactName:
      map['contact_name'] as String?,

      contactPhoneNumber:
      map['contact_phone_number']
      as String?,

      courierMessage:
      map['courier_message']
      as String?,

      label: map['label'] as String?,

      street: map['street'] as String?,

      province:
      map['province'] as String?,

      regency:
      map['regency'] as String?,

      district:
      map['district'] as String?,

      village:
      map['village'] as String?,

      postCode:
      map['post_code'] as String?,

      latitude:
      (map['latitude'] as num?)
          ?.toDouble(),

      longitude:
      (map['longitude'] as num?)
          ?.toDouble(),

      fullAddress:
      map['full_address']
      as String?,
    );
  }

  /// =========================
  /// TO FIRESTORE MAP
  /// =========================

  Map<String, dynamic> toMap() {
    final data = {
      'id': id,

      'contact_name': contactName ?? '',

      'contact_phone_number':
      contactPhoneNumber ?? '',

      'courier_message':
      courierMessage ?? '',

      'label': label ?? '',

      'street': street ?? '',

      'province': province ?? '',

      'regency': regency ?? '',

      'district': district ?? '',

      'village': village ?? '',

      'post_code': postCode ?? '',

      'latitude': latitude ?? '',

      'longitude': longitude ?? '',

      'full_address': fullAddress ?? '',
    };
    return data;
  }

  /// =========================
  /// COPY WITH
  /// =========================

  AddressModel copyWith({
    String? id,
    String? contactName,
    String? contactPhoneNumber,
    String? courierMessage,
    String? label,
    double? latitude,
    double? longitude,
    String? street,
    String? province,
    String? regency,
    String? district,
    String? village,
    String? postCode,
    String? fullAddress,
  }) {
    return AddressModel(
      id: id ?? this.id,

      contactName:
      contactName ??
          this.contactName,

      contactPhoneNumber:
      contactPhoneNumber ??
          this.contactPhoneNumber,

      courierMessage:
      courierMessage ??
          this.courierMessage,

      label: label ?? this.label,

      latitude:
      latitude ?? this.latitude,

      longitude:
      longitude ?? this.longitude,

      street: street ?? this.street,

      province:
      province ?? this.province,

      regency:
      regency ?? this.regency,

      district:
      district ?? this.district,

      village:
      village ?? this.village,

      postCode:
      postCode ?? this.postCode,

      fullAddress:
      fullAddress ??
          this.fullAddress,
    );
  }

  /// =========================
  /// EMPTY HELPER
  /// =========================

  factory AddressModel.empty() {
    return const AddressModel(
      id: '',

      contactName: '',
      contactPhoneNumber: '',

      courierMessage: '',
      label: '',

      latitude: 0,
      longitude: 0,

      street: '',
      province: '',
      regency: '',
      district: '',
      village: '',
      postCode: '',

      fullAddress: '',
    );
  }
}