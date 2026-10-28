import 'package:flutter/material.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_primitives.dart';

class ManageOrderDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final OrderModel order;
  final VoidCallback onBack;

  const ManageOrderDetailAppBar({
    super.key,
    required this.order,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);

  @override
  Widget build(BuildContext context) {
    final badge = OrderStatusConfig.badge(order.status);

    return AppBar(
      backgroundColor: OrderDetailTheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: onBack,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: OrderDetailTheme.iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 16,
            color: OrderDetailTheme.textPrimary,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Pesanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OrderDetailTheme.textPrimary,
            ),
          ),
          Text(
            order.orderNumber,
            style: const TextStyle(
              fontSize: 10,
              color: OrderDetailTheme.textMuted,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Center(child: StatusBadge(config: badge)),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(height: 0.5, color: OrderDetailTheme.border),
      ),
    );
  }
}

class ManageOrderBottomBar extends StatelessWidget {
  final OrderStatus status;
  final DeliveryMethod deliveryMethod;
  final bool isLoading;
  final VoidCallback onReject;
  final VoidCallback onConfirm;
  final VoidCallback onProcessed;
  final VoidCallback onMarkPickedUp;
  final VoidCallback onItemOnRent;
  final VoidCallback onConfirmReturn;
  final VoidCallback onMarkReturned;
  final VoidCallback onInspection;
  final VoidCallback onComplete;

  const ManageOrderBottomBar({
    super.key,
    required this.status,
    required this.deliveryMethod,
    required this.isLoading,
    required this.onReject,
    required this.onConfirm,
    required this.onProcessed,
    required this.onMarkPickedUp,
    required this.onItemOnRent,
    required this.onConfirmReturn,
    required this.onMarkReturned,
    required this.onInspection,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _actionsForStatus();
    if (actions == null) return const SizedBox.shrink();

    return Container(
      color: OrderDetailTheme.surface,
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
      case OrderStatus.waitingConfirmation:
        return Row(
          children: [
            Expanded(
              child: ActionButton.danger(label: 'Tolak', onTap: onReject),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ActionButton.primary(
                label: 'Konfirmasi Pesanan',
                onTap: onConfirm,
              ),
            ),
          ],
        );
      case OrderStatus.processing:
        return ActionButton.primary(
          label: deliveryMethod == DeliveryMethod.renterPickup
              ? 'Tandai Siap Diambil'
              : 'Tandai Sudah Dikirim',
          onTap: onProcessed,
        );
      case OrderStatus.waitingPickup:
        return ActionButton.primary(
          label: 'Tandai Sudah Diambil',
          onTap: onMarkPickedUp,
        );
      case OrderStatus.delivered:
        return ActionButton.primary(label: 'Mulai Sewa', onTap: onItemOnRent);
      case OrderStatus.onRent:
        return null;
      case OrderStatus.lateReturn:
        return null;
      case OrderStatus.returnOnDelivery:
        return ActionButton.primary(
          label: 'Barang diterima',
          onTap: onConfirmReturn,
        );
      case OrderStatus.onInspection:
        return ActionButton.primary(label: 'Selesaikan Pesanan', onTap: onInspection);
      case OrderStatus.damageClaim:
        return null;
      case OrderStatus.returned:
        return null;

      default:
        return null;
    }
  }
}