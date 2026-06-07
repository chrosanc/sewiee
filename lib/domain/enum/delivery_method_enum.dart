import 'package:flutter/material.dart';

enum DeliveryMethod { renterPickup, merchantDelivery, expedition }

extension DeliveryMethodX on DeliveryMethod {
  String get value {
    switch (this){
      case DeliveryMethod.renterPickup:
        return 'pickup';
      case DeliveryMethod.merchantDelivery:
        return 'seller_delivery';
      case DeliveryMethod.expedition:
        return 'expedition_return';
    }
  }

  String get label {
    switch (this) {
      case DeliveryMethod.renterPickup:
        return 'Ambil Sendiri';
      case DeliveryMethod.merchantDelivery:
        return 'Antar Merchant';
      case DeliveryMethod.expedition:
        return 'Ekspedisi';
    }
  }

  String get subtitle {
    switch (this) {
      case DeliveryMethod.renterPickup:
        return 'Penyewa datang ke toko';
      case DeliveryMethod.merchantDelivery:
        return 'Merchant antar ke alamat';
      case DeliveryMethod.expedition:
        return 'Kirim via kurir pilihan';
    }
  }

  IconData get icon {
    switch (this) {
      case DeliveryMethod.renterPickup:
        return Icons.directions_walk_outlined;
      case DeliveryMethod.merchantDelivery:
        return Icons.pedal_bike_outlined;
      case DeliveryMethod.expedition:
        return Icons.inventory_2_outlined;
    }
  }

  Color get iconBg {
    switch (this) {
      case DeliveryMethod.renterPickup:
        return const Color(0xFFE6F1FB);
      case DeliveryMethod.merchantDelivery:
        return const Color(0xFFEEEDFE);
      case DeliveryMethod.expedition:
        return const Color(0xFFE1F5EE);
    }
  }

  Color get iconColor {
    switch (this) {
      case DeliveryMethod.renterPickup:
        return const Color(0xFF185FA5);
      case DeliveryMethod.merchantDelivery:
        return const Color(0xFF534AB7);
      case DeliveryMethod.expedition:
        return const Color(0xFF0F6E56);
    }
  }

  static DeliveryMethod fromString(String value){
    switch (value){
      case 'pickup':
        return DeliveryMethod.renterPickup;
      case 'seller_delivery' :
        return DeliveryMethod.merchantDelivery;
      case 'expedition_return' :
        return DeliveryMethod.expedition;
      default:
        return DeliveryMethod.renterPickup;
    }

  }
}