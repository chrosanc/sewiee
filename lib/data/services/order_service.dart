import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-southeast2',
  );

  final midtransUrl = 'https://app.sandbox.midtrans.com/snap/v1/transactions';
  final midtransKey = dotenv.get('MIDTRANS_SERVER_API_KEY');

  // =========================
  // CREATE ORDER WITH STOCK RESERVATION (ATOMIC TRANSACTION)
  // =========================

  Future<OrderModel?> createOrderWithStockCheck({
    required String orderId,
    required String productId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      // Gunakan transaction untuk mengurangi stok dan membuat order secara atomik
      await _firestore.runTransaction((transaction) async {
        // 1. Ambil data produk
        final productRef = _firestore.collection('products').doc(productId);
        final productSnapshot = await transaction.get(productRef);

        if (!productSnapshot.exists) {
          throw Exception('Produk tidak ditemukan');
        }

        final currentStock = productSnapshot.data()?['stock'] ?? 0;

        // 2. Cek stok tersedia
        if (currentStock <= 0) {
          throw Exception('Stok produk habis! Silahkan pilih produk lain.');
        }

        // 3. Kurangi stok produk
        transaction.update(productRef, {'stock': currentStock - 1});

        // 4. Buat dokumen order
        transaction.set(_firestore.collection('order').doc(orderId), orderData);
      });

      debugPrint('Order berhasil dibuat dengan stok ter-reservasi');
      return null; // Transaction sudah selesai, tidak perlu return order model lagi
    } catch (e) {
      debugPrint('Error saat create order: $e');
      rethrow;
    }
  }

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
      updateData['shipping.delivery_tracking.status'] = 'delivered';
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
  }) async {

    await _firestore
        .collection('order')
        .doc(orderId)
        .update({

      'status': OrderStatus.returnOnDelivery.value,

      // return tracking
      'shipping.return_tracking.receipt_number':
      receiptNumber,

      'shipping.return_tracking.courier_name':
      courierName,

      // waktu renter kirim barang
      'shipping.return_tracking.shipped_at':
      FieldValue.serverTimestamp(),

      // nanti owner confirm
      'shipping.return_tracking.delivered_at': FieldValue.serverTimestamp(),

      // status tracking
      'shipping.return_tracking.status':
      'on_delivery',

      'updated_at':
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

  Future<void> updateOnReturnDelivered({
    required String orderId,
    required DateTime receivedAt,
  }) {
    return _firestore
        .collection('order')
        .doc(orderId)
        .update({

      // =========================
      // RETURN TRACKING
      // =========================

      'shipping.return_tracking.delivered_at': receivedAt,

      'shipping.return_tracking.status': OrderStatus.delivered.value,

      // =========================
      // ORDER STATUS
      // =========================

      'status': OrderStatus.onInspection.value,

      // =========================
      // TIMESTAMP
      // =========================

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

  Future<Map<String,dynamic>> createPenaltyTransaction({
    required OrderModel order, required UserModel userModel
})async{

    final response = await http.post(Uri.parse(midtransUrl, ), headers: {
      'Accept' : 'application/json',
      'Content-Type' : 'application/json',
      'Authorization' : 'Basic ${base64.encode(utf8.encode('$midtransKey:'))}'
    },
      body: jsonEncode({
        'transaction_details' : {
          'order_id' : 'PENALTY-${order.orderNumber}-${DateTime.now().millisecondsSinceEpoch}',
          'gross_amount' : order.rental.brokenFine
        },
        "credit_card" : {
          'secure' : true,
        },
        "customer_details" : {
          "first_name" : order.renterSnapshot.name,
          "email" : userModel.email,
          "phone" : order.renterSnapshot.phoneNumber
        }
      })
    );


    if(response.statusCode != 201) {
      debugPrint('PENALTYTRANSACTION ERROR : ${response.body}');
    }
    return jsonDecode(response.body);
  }

  // Future<void> updatePaidPenaltyStatus({
  //   required String orderId,
  // }) async {
  //   await _firestore
  //       .collection('order')
  //       .doc(orderId)
  //       .update({
  //
  //     'updatedAt':
  //     FieldValue.serverTimestamp(),
  //   });
  // }


}
