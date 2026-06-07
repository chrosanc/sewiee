import 'package:flutter/material.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';

class RenterOrderBottomBar extends StatelessWidget {
  final OrderStatus status;
  final DeliveryMethod deliveryMethod;
  final bool isLoading;

  final VoidCallback onPay;
  final VoidCallback onCancel;

  final VoidCallback onConfirmArrived;
  final VoidCallback onStartRent;

  final VoidCallback onSubmitReturn;
  final VoidCallback onTrackReturn;

  final VoidCallback onPayPenalty;

  final VoidCallback onHelp;

  const RenterOrderBottomBar({
    super.key,
    required this.status,
    required this.deliveryMethod,
    required this.isLoading,
    required this.onPay,
    required this.onCancel,
    required this.onConfirmArrived,
    required this.onStartRent,
    required this.onSubmitReturn,
    required this.onTrackReturn,
    required this.onPayPenalty,
    required this.onHelp,
  });

  static const _primary = Color(0xFFE8572A);

  @override
  Widget build(BuildContext context) {
    final child = _buildActions();

    if (child == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: isLoading
            ? const SizedBox(
          height: 52,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : child,
      ),
    );
  }

  Widget? _buildActions() {
    switch (status) {

    // =========================
    // WAITING PAYMENT
    // =========================
      case OrderStatus.waitingPayment:
        return Row(
          children: [

            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Batalkan'),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onPay,
                style: _primaryStyle(),
                child: const Text('Bayar Sekarang'),
              ),
            ),
          ],
        );

    // =========================
    // DELIVERY
    // =========================
      case OrderStatus.onDelivery:
        return ElevatedButton.icon(
          onPressed: onConfirmArrived,
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('Barang Sudah Sampai'),
          style: _primaryStyle(),
        );

    // =========================
    // DELIVERED
    // =========================
      case OrderStatus.delivered:
        return ElevatedButton.icon(
          onPressed: onStartRent,
          icon: const Icon(Icons.play_circle_outline),
          label: const Text('Mulai Sewa'),
          style: _primaryStyle(),
        );

    // =========================
    // ON RENT
    // =========================
      case OrderStatus.onRent:
        return ElevatedButton.icon(
          onPressed: onSubmitReturn,
          icon: const Icon(Icons.assignment_return_outlined),
          label: Text(
            deliveryMethod == DeliveryMethod.expedition
                ? 'Kirim Pengembalian'
                : 'Konfirmasi Pengembalian',
          ),
          style: _primaryStyle(),
        );

    // =========================
    // RETURN DELIVERY
    // =========================
      case OrderStatus.returnOnDelivery:
        return ElevatedButton.icon(
          onPressed: onTrackReturn,
          icon: const Icon(Icons.local_shipping_outlined),
          label: const Text('Lacak Pengembalian'),
          style: _primaryStyle(),
        );

    // =========================
    // DAMAGE / LATE
    // =========================
      case OrderStatus.damageClaim:
      case OrderStatus.lateReturn:
        return ElevatedButton.icon(
          onPressed: onPayPenalty,
          icon: const Icon(Icons.payments_outlined),
          label: const Text('Bayar Denda'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
          ),
        );

      default:
        return null;
    }
  }

  ButtonStyle _primaryStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(52),
    );
  }
}