import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/data/services/order_service.dart';
import 'package:sewiee/domain/enum/order_status.dart';

class OrderRepository {
  final OrderService _service = OrderService();

  Future<void> createOrder(OrderModel orderData) async {
    try {
      return await _service.createOrder(orderData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrderWithStockCheck({
    required String orderId,
    required String productId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      await _service.createOrderWithStockCheck(
        orderId: orderId,
        productId: productId,
        orderData: orderData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> generateOrderNumber() async {
    try {
      return await _service.generateOrderNumber();
    } on FirebaseFunctionsException {
      rethrow;
    }
  }

  Future<MidtransTransactionResponseModel?> createTransaction(
    TransactionModel model,
  ) async {
    try {
      return await _service.createTransaction(model);
    } on FirebaseFunctionsException {
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrderByRenterId(String userId) async {
    try {
      return await _service.getOrderByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> streamOrderByRenterId(String userId) {
    return _service.streamOrderByRenterId(userId);
  }

  Stream<List<OrderModel>> streamOrderByOwnerId(String ownerId) {
    return _service.streamOrderByOwnerId(ownerId);
  }

  Stream<OrderModel> streamOrder(String orderId) {
    return _service.streamOrderStatus(orderId);
  }

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
  }) {
    return _service.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
      rentalStartDate: rentalStartDate,
      rentalEndDate: rentalEndDate,
    );
  }

  Future<OrderModel> updateDeliveredStatus({
    required String orderId,
    required OrderStatus newStatus,
    required DateTime deliveredAt,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _service.updateDeliveredStatus(
      orderId: orderId,
      newStatus: newStatus,
      deliveredAt: deliveredAt,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> submitReturnReceipt({
    required String orderId,
    required String receiptNumber,
    required String courierName,
  }) {
    return _service.submitReturnReceipt(
      orderId: orderId,
      receiptNumber: receiptNumber,
      courierName: courierName,
    );
  }

  Future<Map<String,dynamic>> payPenalty({required OrderModel order, required UserModel user}) {
    return _service.createPenaltyTransaction(order: order, userModel: user);
  }

  Future<void> updateRentDate({
    required String orderId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _service.updateRentDate(
      orderId: orderId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> updateDeliveryReceiptNumber({
    required String orderId,
    required String receiptNumber,
  }) {
    return _service.updateDeliveryReceiptNumber(
      orderId: orderId,
      receiptNumber: receiptNumber,
    );
  }

  Future<void> updateOnReturnDelivered({
    required String orderId,
    required DateTime receivedAt,
  }) {
    return _service.updateOnReturnDelivered(
      orderId: orderId,
      receivedAt: receivedAt,
    );
  }

  Future<void> updateInspection({
    required String orderId,
    required int fine,
    required String status,
  }) {
    return _service.updateInspection(
      orderId: orderId,
      brokenFine: fine,
      status: status,
    );
  }
}
