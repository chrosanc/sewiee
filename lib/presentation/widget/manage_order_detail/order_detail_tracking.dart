import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_primitives.dart';

class TrackingCard extends StatelessWidget {
  final _TrackingInfo tracking;
  final String label;

  const TrackingCard._({required this.tracking, required this.label});

  factory TrackingCard.delivery(DeliveryTracking tracking) {
    return TrackingCard._(
      label: 'Pengiriman',
      tracking: _TrackingInfo(
        courierName: tracking.courierName,
        receiptNumber: tracking.receiptNumber,
        status: tracking.status,
        shippedAt: tracking.shippedAt,
        deliveredAt: tracking.deliveredAt,
      ),
    );
  }

  factory TrackingCard.returnOrder(ReturnTracking tracking) {
    return TrackingCard._(
      label: 'Pengembalian',
      tracking: _TrackingInfo(
        courierName: tracking.courierName,
        receiptNumber: tracking.receiptNumber,
        status: tracking.status,
        shippedAt: tracking.shippedAt,
        deliveredAt: tracking.deliveredAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      iconBg: const Color(0xFFE1F5EE),
      iconColor: const Color(0xFF0F6E56),
      iconData: Icons.local_shipping_outlined,
      title: 'Tracking $label',
      child: Column(
        children: [
          InfoRow(label: 'Kurir', value: tracking.courierName ?? '-'),
          InfoRow(
            label: 'No. Resi',
            value: tracking.receiptNumber?.isNotEmpty == true
                ? tracking.receiptNumber!
                : 'Belum tersedia',
          ),
          InfoRow(label: 'Status', value: _statusLabel(tracking.status)),
          if (tracking.shippedAt != null)
            InfoRow(label: 'Dikirim', value: OrderUtils.fmtDate(tracking.shippedAt!)),
          if (tracking.deliveredAt != null)
            InfoRow(
              label: 'Diterima',
              value: OrderUtils.fmtDate(tracking.deliveredAt!),
              last: true,
            )
          else
            const InfoRow(label: '', value: '', last: true),
        ],
      ),
    );
  }

  String _statusLabel(String? value) {
    switch (value) {
      case 'waiting_pickup':
        return 'Menunggu Pickup';
      case 'on_delivery':
        return 'Dalam Pengiriman';
      case 'delivered':
        return 'Sudah Diterima';
      default:
        return value ?? '-';
    }
  }
}

class _TrackingInfo {
  final String? courierName;
  final String? receiptNumber;
  final String? status;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  const _TrackingInfo({
    required this.courierName,
    required this.receiptNumber,
    required this.status,
    required this.shippedAt,
    required this.deliveredAt,
  });
}
