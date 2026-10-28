import 'package:flutter/material.dart';

enum ReturnMethod { selfReturn, merchantPickup, expedition }

extension ReturnMethodX on ReturnMethod {
  String get value {
    switch (this) {
      case ReturnMethod.selfReturn:
        return 'self_return';
      case ReturnMethod.merchantPickup:
        return 'seller_pickup';
      case ReturnMethod.expedition:
        return 'expedition_return';
    }
  }

  String get label {
    switch (this) {
      case ReturnMethod.selfReturn:
        return 'Antar Sendiri';
      case ReturnMethod.merchantPickup:
        return 'Diambil Merchant';
      case ReturnMethod.expedition:
        return 'Ekspedisi';
    }
  }

  String get subtitle {
    switch (this) {
      case ReturnMethod.selfReturn:
        return 'Penyewa antar ke merchant';
      case ReturnMethod.merchantPickup:
        return 'Merchant ambil ke alamat';
      case ReturnMethod.expedition:
        return 'Kirim via kurir pilihan';
    }
  }

  IconData get icon {
    switch (this) {
      case ReturnMethod.selfReturn:
        return Icons.directions_walk_outlined;
      case ReturnMethod.merchantPickup:
        return Icons.pedal_bike_outlined;
      case ReturnMethod.expedition:
        return Icons.inventory_2_outlined;
    }
  }

  Color get iconBg {
    switch (this) {
      case ReturnMethod.selfReturn:
        return const Color(0xFFE6F1FB);
      case ReturnMethod.merchantPickup:
        return const Color(0xFFEEEDFE);
      case ReturnMethod.expedition:
        return const Color(0xFFE1F5EE);
    }
  }

  Color get iconColor {
    switch (this) {
      case ReturnMethod.selfReturn:
        return const Color(0xFF185FA5);
      case ReturnMethod.merchantPickup:
        return const Color(0xFF534AB7);
      case ReturnMethod.expedition:
        return const Color(0xFF0F6E56);
    }
  }

  static ReturnMethod fromString(String value) {
    switch (value) {
      case 'self_return':
      case 'pickup':
        return ReturnMethod.selfReturn;
      case 'seller_pickup':
      case 'seller_delivery':
        return ReturnMethod.merchantPickup;
      case 'expedition_return':
      case 'expedition':
        return ReturnMethod.expedition;
      default:
        return ReturnMethod.selfReturn;
    }
  }
}
