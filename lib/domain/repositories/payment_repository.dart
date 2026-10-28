import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/data/services/payment_service.dart';

class PaymentRepository {
  final PaymentService service = PaymentService();

  Future<List<PaymentMethodModel>> getPaymentMethod() async {
    try {
      return await service.getPaymentMethods();
    } catch (e) {
      rethrow;
    }
  }
}
