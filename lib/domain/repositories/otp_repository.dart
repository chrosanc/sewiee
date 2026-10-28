import 'package:sewiee/data/services/otp_service.dart';

class OtpRepository {


  final OtpService otpService = OtpService();

  Future<Map<String,dynamic>> sendOtp(String phone) async {
    return otpService.sendOtp(phone);
  }

  Future<Map<String, dynamic>> verifyOtp(String otp, String phone) async {
    return otpService.verifyOtp(otp, phone);
  }
}