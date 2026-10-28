import 'package:flutter/material.dart';

enum OrderStatus {
  waitingPayment,
  paymentExpired,
  paymentFailed,

  paid,
  waitingConfirmation,
  processing,

  waitingPickup,
  onDelivery,
  delivered,

  onRent,

  returnPending,
  returnOnDelivery,
  returned,

  onInspection,
  damageClaim,

  completed,
  cancelled,

  lateReturn,
}

// =========================
// STATUS VALUE
// =========================

extension OrderStatusX on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.waitingPayment:
        return 'waiting_payment';

      case OrderStatus.paymentExpired:
        return 'payment_expired';

      case OrderStatus.paymentFailed:
        return 'payment_failed';

      case OrderStatus.paid:
        return 'paid';

      case OrderStatus.waitingConfirmation:
        return 'waiting_confirmation';

      case OrderStatus.processing:
        return 'processing';

      case OrderStatus.waitingPickup:
        return 'waiting_pickup';

      case OrderStatus.onDelivery:
        return 'on_delivery';

      case OrderStatus.delivered:
        return 'delivered';

      case OrderStatus.onRent:
        return 'on_rent';

      case OrderStatus.returnPending:
        return 'return_pending';

      case OrderStatus.returnOnDelivery:
        return 'return_on_delivery';

      case OrderStatus.returned:
        return 'returned';

      case OrderStatus.completed:
        return 'completed';

      case OrderStatus.cancelled:
        return 'cancelled';

      case OrderStatus.lateReturn:
        return 'late_return';
      case OrderStatus.onInspection:
        return 'on_inspection';
      case OrderStatus.damageClaim:
        return 'damage_claimed';
    }
  }

  // =========================
  // LABEL
  // =========================

  String get label {
    switch (this) {
      case OrderStatus.waitingPayment:
        return 'Menunggu Pembayaran';

      case OrderStatus.paymentExpired:
        return 'Pembayaran Kadaluarsa';

      case OrderStatus.paymentFailed:
        return 'Pembayaran Gagal';

      case OrderStatus.paid:
        return 'Sudah Dibayar';

      case OrderStatus.waitingConfirmation:
        return 'Menunggu Konfirmasi';

      case OrderStatus.processing:
        return 'Pesanan Diproses';

      case OrderStatus.waitingPickup:
        return 'Menunggu Pickup';

      case OrderStatus.onDelivery:
        return 'Dalam Pengiriman';

      case OrderStatus.delivered:
        return 'Sudah Diterima';

      case OrderStatus.onRent:
        return 'Sedang Disewa';

      case OrderStatus.returnPending:
        return 'Menunggu Pengembalian';

      case OrderStatus.returnOnDelivery:
        return 'Pengembalian Dikirim';

      case OrderStatus.returned:
        return 'Sudah Dikembalikan';

      case OrderStatus.completed:
        return 'Selesai';

      case OrderStatus.cancelled:
        return 'Dibatalkan';

      case OrderStatus.lateReturn:
        return 'Terlambat Dikembalikan';
      case OrderStatus.onInspection:
        return 'Pengecekan Barang';
      case OrderStatus.damageClaim:
        return 'Barang rusak';
    }
  }

  // =========================
  // COLOR
  // =========================

  Color get color {
    switch (this) {
      case OrderStatus.waitingPayment:
      case OrderStatus.waitingConfirmation:
        return Colors.orange;

      case OrderStatus.paymentExpired:
      case OrderStatus.paymentFailed:
      case OrderStatus.cancelled:
        return Colors.red;

      case OrderStatus.paid:
      case OrderStatus.processing:
      case OrderStatus.waitingPickup:
      case OrderStatus.onDelivery:
      case OrderStatus.returnPending:
      case OrderStatus.returnOnDelivery:
        return Colors.blue;

      case OrderStatus.delivered:
      case OrderStatus.onRent:
        return Colors.deepPurple;

      case OrderStatus.returned:
      case OrderStatus.completed:
        return Colors.green;


      case OrderStatus.onInspection:
      case OrderStatus.damageClaim:
      case OrderStatus.lateReturn:
        return Colors.deepOrange;

    }
  }

  // =========================
  // FROM STRING
  // =========================

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'waiting_payment':
        return OrderStatus.waitingPayment;

      case 'payment_expired':
        return OrderStatus.paymentExpired;

      case 'payment_failed':
        return OrderStatus.paymentFailed;

      case 'paid':
        return OrderStatus.paid;

      case 'waiting_confirmation':
        return OrderStatus.waitingConfirmation;

      case 'processing':
        return OrderStatus.processing;

      case 'waiting_pickup':
        return OrderStatus.waitingPickup;

      case 'on_delivery':
        return OrderStatus.onDelivery;

      case 'delivered':
        return OrderStatus.delivered;

      case 'on_rent':
        return OrderStatus.onRent;

      case 'return_pending':
        return OrderStatus.returnPending;

      case 'return_on_delivery':
        return OrderStatus.returnOnDelivery;

      case 'returned':
        return OrderStatus.returned;

      case 'completed':
        return OrderStatus.completed;

      case 'cancelled':
        return OrderStatus.cancelled;

      case 'late_return':
        return OrderStatus.lateReturn;

      case 'on_inspection' :
        return OrderStatus.onInspection;

      case 'damage_claimed' :
        return OrderStatus.damageClaim;

      default:
        return OrderStatus.waitingPayment;
    }
  }
}

// =========================
// ORDER FLOW
// =========================

class OrderFlow {
  static const Map<OrderStatus, List<OrderStatus>> allowed = {
    OrderStatus.waitingPayment: [
      OrderStatus.paid,
      OrderStatus.paymentExpired,
      OrderStatus.paymentFailed,
      OrderStatus.cancelled,
    ],

    OrderStatus.paid: [
      OrderStatus.processing,
      OrderStatus.waitingConfirmation,
      OrderStatus.cancelled,
    ],

    OrderStatus.processing: [
      OrderStatus.waitingPickup,
      OrderStatus.onDelivery,
    ],

    OrderStatus.waitingPickup: [
      OrderStatus.onDelivery,
    ],

    OrderStatus.onDelivery: [
      OrderStatus.delivered,
    ],

    OrderStatus.delivered: [
      OrderStatus.onRent,
    ],

    OrderStatus.onRent: [
      OrderStatus.returnPending,
      OrderStatus.lateReturn,
    ],

    OrderStatus.returnPending: [
      OrderStatus.returnOnDelivery,
      OrderStatus.returned,
    ],

    OrderStatus.returnOnDelivery: [
      OrderStatus.returned,
    ],

    OrderStatus.returned: [
      OrderStatus.completed,
    ],

    OrderStatus.lateReturn: [
      OrderStatus.returned,
    ],
  };

  static bool canMove(OrderStatus from, OrderStatus to) {
    return allowed[from]?.contains(to) ?? false;
  }
}