class OtpModel {
  final String phoneNumber;
  final String otp;
  final int expiredAt;

  OtpModel({
    required this.phoneNumber,
    required this.otp,
    required this.expiredAt,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      phoneNumber: json['phone'],
      otp: json['otp'],
      expiredAt: json['expiredAt'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'phone' : phoneNumber,
      'otp' : otp,
      'expiredAt' : expiredAt
    };
  }
}
