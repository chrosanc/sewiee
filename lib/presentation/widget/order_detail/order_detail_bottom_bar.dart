import 'package:flutter/material.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';

class RenterOrderBottomBar extends StatelessWidget {
  final OrderStatus status;
  final DeliveryMethod deliveryMethod;
  final bool isLoading;

  final VoidCallback onPay;
  final VoidCallback onCancel;
  final VoidCallback onTrack;
  final VoidCallback onConfirmPickup;
  final VoidCallback onStartRent;
  final VoidCallback onConfirmReturn;
  final VoidCallback onHelp;

  const RenterOrderBottomBar({
    super.key,
    required this.status,
    required this.deliveryMethod,
    required this.isLoading,
    required this.onPay,
    required this.onCancel,
    required this.onTrack,
    required this.onConfirmPickup,
    required this.onStartRent,
    required this.onConfirmReturn,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _actionsForStatus();
    if (actions == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : actions,
        ),
      ),
    );
  }

  Widget? _actionsForStatus() {
    switch (status) {

    /// =======================
    /// WAITING PAYMENT
    /// =======================
      case OrderStatus.waitingPayment:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('Batalkan'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onPay,
                child: const Text('Bayar Sekarang'),
              ),
            ),
          ],
        );

    /// =======================
    /// PROCESSING (seller proses)
    /// =======================
      case OrderStatus.processing:
        return ElevatedButton(
          onPressed: onTrack,
          child: const Text('Lacak Pesanan'),
        );

    /// =======================
    /// READY / WAIT PICKUP
    /// =======================
      case OrderStatus.waitingPickup:
        return ElevatedButton(
          onPressed: onConfirmPickup,
          child: Text(
            deliveryMethod == DeliveryMethod.renterPickup
                ? 'Saya Sudah Ambil Barang'
                : 'Konfirmasi Barang Diterima',
          ),
        );

    /// =======================
    /// DELIVERED → START RENT
    /// =======================
      case OrderStatus.delivered:
        return ElevatedButton(
          onPressed: onStartRent,
          child: const Text('Mulai Sewa'),
        );

    /// =======================
    /// ON RENT
    /// =======================
      case OrderStatus.onRent:
        return ElevatedButton(
          onPressed: onTrack,
          child: const Text('Lihat Status Sewa'),
        );

    /// =======================
    /// RETURN PROCESS
    /// =======================
      case OrderStatus.returnOnDelivery:
        return ElevatedButton(
          onPressed: onConfirmReturn,
          child: const Text('Konfirmasi Pengembalian'),
        );

    /// =======================
    /// RETURNED / DONE
    /// =======================
      case OrderStatus.returned:
        return ElevatedButton(
          onPressed: onHelp,
          child: const Text('Bantuan / Komplain'),
        );

    /// =======================
    /// LATE / DAMAGE
    /// =======================
      case OrderStatus.lateReturn:
      case OrderStatus.damageClaim:
        return ElevatedButton(
          onPressed: onHelp,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Hubungi CS'),
        );

      default:
        return null;
    }
  }
}