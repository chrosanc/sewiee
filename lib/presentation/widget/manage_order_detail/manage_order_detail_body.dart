import 'package:flutter/material.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/domain/enum/return_method_enum.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_primitives.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_tracking.dart';

class ManageOrderDetailBody extends StatelessWidget {
  final OrderModel order;

  const ManageOrderDetailBody({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final deliveryMethod = DeliveryMethodX.fromString(order.shipping.deliveryMethod);
    final returnMethod = ReturnMethodX.fromString(order.shipping.returnMethod);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      child: Column(
        children: [
          _StatusBannerCard(status: order.status, model: order,),
          const SizedBox(height: 10),
          _RenterCard(order: order),
          const SizedBox(height: 10),
          _ProductCard(order: order),
          const SizedBox(height: 10),
          _DeliveryCard(
            selected: deliveryMethod,
            readOnly: order.status != OrderStatus.processing,
          ),
          const SizedBox(height: 10),
          _ReturnCard(
            selected: returnMethod,
            readOnly: order.status != OrderStatus.processing,
          ),
          const SizedBox(height: 10),
          if (order.shipping.deliveryTracking != null) ...[
            TrackingCard.delivery(order.shipping.deliveryTracking!),
            const SizedBox(height: 10),
          ],
          if (order.shipping.returnTracking != null) ...[
            TrackingCard.returnOrder(order.shipping.returnTracking!),
            const SizedBox(height: 10),
          ],
          // OrderTimelineCard(
          //   status: order.status,
          //   deliveryMethod: deliveryMethod,
          //   returnMethod: returnMethod,
          // ),
          _PaymentSummaryCard(order: order),
        ],
      ),
    );
  }
}

// ── Status banner ─────────────────────────────────────────────────────────────

class _StatusBannerCard extends StatelessWidget {
  final OrderStatus status;
  final OrderModel? model;

  const _StatusBannerCard({required this.status, this.model});

  @override
  Widget build(BuildContext context) {
    final cfg = OrderStatusConfig.banner(status, model);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cfg.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: cfg.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cfg.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cfg.titleColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  cfg.subtitle,
                  style: TextStyle(fontSize: 10, color: cfg.subtitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Renter card ───────────────────────────────────────────────────────────────

class _RenterCard extends StatelessWidget {
  final OrderModel order;

  const _RenterCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final renter = order.renterSnapshot;
    final address = order.address.renter;

    return SectionCard(
      iconBg: const Color(0xFFE6F1FB),
      iconColor: const Color(0xFF185FA5),
      iconData: Icons.person_outline,
      title: 'Penyewa',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F1FB),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    OrderUtils.initials(renter.name),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF185FA5),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        renter.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: OrderDetailTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        address.contactPhoneNumber ?? '-',
                        style: const TextStyle(
                          fontSize: 11,
                          color: OrderDetailTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: OrderDetailTheme.iconBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 12, color: OrderDetailTheme.textPrimary),
                      SizedBox(width: 4),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: OrderDetailTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, color: OrderDetailTheme.divider, indent: 14, endIndent: 14),
          InfoRow(label: 'Username', value: '@${renter.username}'),
          InfoRow(label: 'Alamat', value: address.fullAddress ?? '-', last: true),
        ],
      ),
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final OrderModel order;

  const _ProductCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final product = order.productSnapshot;
    final currency = CurrencyUtils();

    return SectionCard(
      iconBg: const Color(0xFFFAEEDA),
      iconColor: const Color(0xFF854F0B),
      iconData: Icons.inventory_2_outlined,
      title: 'Produk',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ProductImageFallback(),
                    )
                  : const ProductImageFallback(),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: OrderDetailTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _durationText(order.rental, product.durationType),
                    style: const TextStyle(fontSize: 11, color: OrderDetailTheme.textMuted),
                  ),
                ],
              ),
            ),
            Text(
              currency.toRupiah(product.price),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: OrderDetailTheme.priceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _durationText(RentalDetail rental, String durationType) {
    if (rental.startDate != null && rental.endDate != null) {
      final start = OrderUtils.fmtDate(rental.startDate!);
      final end = OrderUtils.fmtDate(rental.endDate!);
      return '$start - $end - ${rental.totalDuration} $durationType';
    }
    return '${rental.totalDuration} $durationType';
  }
}

// ── Delivery & return method cards ────────────────────────────────────────────

class _DeliveryCard extends StatelessWidget {
  final DeliveryMethod selected;
  final bool readOnly;

  const _DeliveryCard({required this.selected, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      iconBg: const Color(0xFFEEEDFE),
      iconColor: const Color(0xFF534AB7),
      iconData: Icons.local_shipping_outlined,
      title: 'Metode Pengiriman',
      child: Column(
        children: DeliveryMethod.values.map((method) {
          return _MethodRow(
            iconBg: method.iconBg,
            iconColor: method.iconColor,
            icon: method.icon,
            label: method.label,
            subtitle: method.subtitle,
            selected: method == selected,
            readOnly: readOnly,
            isLast: method == DeliveryMethod.values.last,
          );
        }).toList(),
      ),
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final ReturnMethod selected;
  final bool readOnly;

  const _ReturnCard({required this.selected, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      iconBg: const Color(0xFFEEEDFE),
      iconColor: const Color(0xFF534AB7),
      iconData: Icons.assignment_return_outlined,
      title: 'Metode Pengembalian',
      child: Column(
        children: ReturnMethod.values.map((method) {
          return _MethodRow(
            iconBg: method.iconBg,
            iconColor: method.iconColor,
            icon: method.icon,
            label: method.label,
            subtitle: method.subtitle,
            selected: method == selected,
            readOnly: readOnly,
            isLast: method == ReturnMethod.values.last,
          );
        }).toList(),
      ),
    );
  }
}

/// Shared row for both delivery and return method lists.
class _MethodRow extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final bool readOnly;
  final bool isLast;

  const _MethodRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.readOnly,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: selected ? 1 : (readOnly ? 0.35 : 0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                MethodIcon(color: iconBg, iconColor: iconColor, icon: icon),
                const SizedBox(width: 10),
                MethodText(title: label, subtitle: subtitle),
                SelectionIndicator(selected: selected),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 0.5,
            color: OrderDetailTheme.divider,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}

// ── Payment summary card ──────────────────────────────────────────────────────

class _PaymentSummaryCard extends StatelessWidget {
  final OrderModel order;

  const _PaymentSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final amount = order.payment.amount;
    final currency = CurrencyUtils();

    return SectionCard(
      iconBg: const Color(0xFFEAF3DE),
      iconColor: const Color(0xFF3B6D11),
      iconData: Icons.receipt_long_outlined,
      title: 'Ringkasan Pembayaran',
      child: Column(
        children: [
          InfoRow(label: 'Harga produk', value: currency.toRupiah(amount.productPrice)),
          InfoRow(label: 'Deposit', value: currency.toRupiah(amount.depositAmount)),
          InfoRow(label: 'Biaya pengiriman', value: currency.toRupiah(amount.deliveryFee)),
          InfoRow(label: 'Biaya layanan', value: currency.toRupiah(amount.serviceFee)),
          InfoRow(label: 'Biaya aplikasi', value: currency.toRupiah(amount.applicationFee)),
          const Divider(height: 0.5, color: OrderDetailTheme.divider, indent: 14, endIndent: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: OrderDetailTheme.textPrimary,
                  ),
                ),
                Text(
                  currency.toRupiah(amount.totalPayment),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: OrderDetailTheme.priceColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, color: OrderDetailTheme.divider, indent: 14, endIndent: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Metode Bayar',
                  style: TextStyle(fontSize: 12, color: OrderDetailTheme.textMuted),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (order.payment.paymentMethod.image.isNotEmpty)
                        Image.network(
                          order.payment.paymentMethod.image,
                          height: 18,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          order.payment.paymentMethod.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: OrderDetailTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
