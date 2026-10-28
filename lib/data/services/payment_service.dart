import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sewiee/data/model/payment_model.dart';

class PaymentService {
  String url =
      'https://us-central1-sewiee-a313a.cloudfunctions.net/getPaymentMethods';

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil metode pembayaran');
    }

    final json = jsonDecode(response.body);
    final List paymentMethods = json['data'] ?? [];
    return paymentMethods.map((e) => PaymentMethodModel.fromJson(e)).toList();
  }
}
