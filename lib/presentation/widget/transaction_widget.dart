import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class TransactionWidget extends StatelessWidget {
  final bool enabledButton;
  final Function() onTap;
  final OrderStatus status;
  final Function() buttonOnTap;
  final String? productName;
  final String? duration;
  final String? totalPay;
  final String? productImage;
  final String? buttonLabel;
  final String? storeName;

  const TransactionWidget({
    super.key,
    required this.enabledButton,
    required this.onTap,
    required this.status,
    required this.buttonOnTap,
    this.productName,
    this.duration,
    this.totalPay,
    this.productImage,
    this.buttonLabel, this.storeName,
  });

  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF1A1A2E);
  static const _inkSub = Color(0xFF6B7280);
  static const _border = Color(0xFFECEBE8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: _ink.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(status: status, storeName: storeName ?? 'Sewiee',),
              const Gap(12),
              _ProductRow(
                productImage: productImage,
                productName: productName,
                duration: duration,
              ),
              const Gap(12),
              const Divider(height: 1, color: _border),
              const Gap(10),
              _FooterRow(
                totalPay: totalPay,
                enabledButton: enabledButton,
                buttonLabel: buttonLabel,
                buttonOnTap: buttonOnTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar: store name + pill badge ─────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final OrderStatus status;
  final String storeName;
  const _TopBar({required this.status, required this.storeName});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.storefront_rounded, size: 13, color: TransactionWidget._inkSub),
            const Gap(5),
            Text(
              storeName,
              style: TextStyle(
                fontSize: 11,
                color: TransactionWidget._inkSub,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Product row ───────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final String? productImage;
  final String? productName;
  final String? duration;

  const _ProductRow({this.productImage, this.productName, this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProductImage(imageUrl: productImage),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName ?? 'Nama Produk',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: TransactionWidget._ink,
                  letterSpacing: -0.2,
                ),
              ),
              const Gap(3),
              Text(
                duration ?? '1 Bulan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: TransactionWidget._inkSub,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: TransactionWidget._inkSub,
          size: 18,
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imageUrl != null
          ? Image.network(
        imageUrl!,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 54,
      height: 54,
      color: const Color(0xFFF0EEE9),
      child: const Icon(
        Icons.checkroom_rounded,
        color: TransactionWidget._inkSub,
        size: 24,
      ),
    );
  }
}

// ── Footer row ────────────────────────────────────────────────────────────────

class _FooterRow extends StatelessWidget {
  final String? totalPay;
  final bool enabledButton;
  final String? buttonLabel;
  final Function() buttonOnTap;

  const _FooterRow({
    required this.totalPay,
    required this.enabledButton,
    required this.buttonOnTap,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Belanja',
              style: TextStyle(fontSize: 10, color: TransactionWidget._inkSub),
            ),
            const Gap(2),
            Text(
              totalPay ?? 'Rp 100.000',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: TransactionWidget._ink,
              ),
            ),
          ],
        ),
        if (enabledButton)
          SizedBox(
            height: 30,
            child: SecondaryButton(
              isActive: true,
              onPressed: buttonOnTap,
              label: buttonLabel ?? 'Tombol',
            ),
          ),
      ],
    );
  }
}