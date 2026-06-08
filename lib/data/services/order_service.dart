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

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
  }) async {

    final docRef = _firestore.collection('order').doc(orderId);

    final Map<String, dynamic> updateData = {
      'status': newStatus.value,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // optional update rental date
    if (rentalStartDate != null) {
      updateData['rental.start_date'] = Timestamp.fromDate(rentalStartDate);
    }

    if (rentalEndDate != null) {
      updateData['rental.end_date'] = Timestamp.fromDate(rentalEndDate);
    }

    await docRef.update(updateData);

    // ambil data terbaru
    final snapshot = await docRef.get();

    return OrderModel.fromJson(snapshot.data()!);
  }


  Future<OrderModel> updateDeliveredStatus({
    required String orderId,
    required OrderStatus newStatus,
    required DateTime deliveredAt,
    required DateTime startDate,
    required DateTime endDate,
  }) async {

    final docRef = _firestore.collection('order').doc(orderId);

    final Map<String, dynamic> updateData = {
      'status': newStatus.value,
      'updatedAt': FieldValue.serverTimestamp(),
    };
      updateData['shipping.delivery_tracking.delivered_at'] = Timestamp.fromDate(deliveredAt);
    // optional update rental date
      updateData['rental.start_date'] = Timestamp.fromDate(startDate);
      updateData['rental.end_date'] = Timestamp.fromDate(endDate);


    await docRef.update(updateData);

    // ambil data terbaru
    final snapshot = await docRef.get();

    return OrderModel.fromJson(snapshot.data()!);
  }


  Future<void> submitReturnReceipt({
    required String orderId,
    required String receiptNumber,
    required String courierName,
    required String courierCode,
  }) async {

    await _firestore
        .collection('order')
        .doc(orderId)
        .update({

      'status': OrderStatus.returnOnDelivery.value,

      // return tracking
      'shipping.returnTracking.receiptNumber':
      receiptNumber,

      'shipping.returnTracking.courierName':
      courierName,

      'shipping.returnTracking.courierCode':
      courierCode,

      // waktu renter kirim barang
      'shipping.returnTracking.shippedAt':
      FieldValue.serverTimestamp(),

      // nanti owner confirm
      'shipping.returnTracking.deliveredAt':
      null,

      // nanti owner klik barang diterima
      'shipping.returnTracking.receivedAt':
      null,

      // status tracking
      'shipping.returnTracking.status':
      'on_delivery',

      'updatedAt':
      FieldValue.serverTimestamp(),
    });
  }

  Future<void> payPenalty({
    required String orderId,
  }) async {

    await _firestore
        .collection('order')
        .doc(orderId)
        .update({

      'penalty.isPaid': true,

      'updatedAt':
      FieldValue.serverTimestamp(),
    });
  }

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

  Stream<OrderModel> streamOrderStatus(String orderId) {
    return FirebaseFirestore.instance
        .collection('order')
        .doc(orderId)
        .snapshots()
        .map((snapshot) {

      final data = snapshot.data();

      if (data == null) {
        throw Exception('Order tidak ditemukan');
      }

      return OrderModel.fromJson(data);
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
