import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OtpService {
  final String sendOtpUrl = dotenv.get('SEND_OTP_API');
  final String verifyOtpUrl = dotenv.get('VERIFY_OTP_API');

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse(sendOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse(verifyOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    return jsonDecode(response.body);
  }
}
