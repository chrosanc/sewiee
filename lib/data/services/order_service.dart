import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-southeast2',
  );

  Future<void> createOrder(OrderModel orderData) async {
    return await _firestore
        .collection('order')
        .doc(orderData.id)
        .set(orderData.toJson());
  }

  Future<List<OrderModel>> getOrderByUserId(String userId) async {
    final result = await _firestore
        .collection('order')
        .where('renter_id', isEqualTo: userId)
        .get();

    return result.docs.map((docs) => OrderModel.fromJson(docs.data())).toList();
  }

  Stream<List<OrderModel>> streamOrderByRenterId(String renterId) {
    return FirebaseFirestore.instance
        .collection('order')
        .where('renter_id', isEqualTo: renterId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OrderModel.fromJson(doc.data());
          }).toList();
        });
  }

  Stream<List<OrderModel>> streamOrderByOwnerId(String ownerId) {
    return FirebaseFirestore.instance
        .collection('order')
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OrderModel.fromJson(doc.data());
          }).toList();
        });
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) {
    return _firestore.collection('order').doc(orderId).update({
      'status': newStatus.value,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateRentDate({
    required String orderId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _firestore.collection('order').doc(orderId).update({
      'rental.start_date': startDate,
      'rental.end_date': endDate,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDeliveryReceiptNumber({
    required String orderId,
    required String receiptNumber,
  }) {
    return _firestore.collection('order').doc(orderId).update({
      'shipping.delivery_tracking.receipt_number': receiptNumber,
      'shipping.delivery_tracking.status': 'on_delivery',
      'shipping.delivery_tracking.shipped_at': FieldValue.serverTimestamp(),
      'status': OrderStatus.onDelivery.value,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateInspection({
    required String orderId,
    required String status,
    required int brokenFine,
  }) {
    return _firestore.collection('order').doc(orderId).update({
      'rental.broken_fine': brokenFine,
      'status': status,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<String> generateOrderNumber() async {
    final callable = _functions.httpsCallable('generateOrderNumber');

    final result = await callable.call();

    final String orderNumber = result.data['order_number'];
    return orderNumber;
  }

  Future<MidtransTransactionResponseModel> createTransaction(
    TransactionModel model,
  ) async {
    final HttpsCallable callable = _functions.httpsCallable(
      'createMidtransTransaction',
    );

    final result = await callable.call(model.toJson());

    debugPrint('TRANSACTION RESULT : ${result.data}');

    return MidtransTransactionResponseModel.fromJson(
      Map<String, dynamic>.from(result.data),
    );
  }
}
