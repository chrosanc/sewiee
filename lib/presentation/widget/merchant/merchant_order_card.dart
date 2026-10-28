import 'package:flutter/material.dart';
import 'package:sewiee/domain/enum/order_status.dart';

// ── Light-theme color constants ───────────────────────────────────────────────
const _textPrimary   = Color(0xFF1A1A18);
const _textSecondary = Color(0xFF888780);
const _priceColor    = Color(0xFFBA7517);
const _imageBg       = Color(0xFFF1EFE8);
const _imageIcon     = Color(0xFFB4B2A9);

class MerchantOrderCard extends StatelessWidget {
  final String productName;
  final String duration;      // e.g. "14 Mei – 14 Jun 2025"
  final String durationType;
  final String totalPayment;  // e.g. "Rp 100.000"
  final String image;         // asset / network URL
  final OrderStatus status;
  final Function()? onTap;

  const MerchantOrderCard({
    super.key,
    required this.productName,
    required this.duration,
    required this.durationType,
    required this.totalPayment,
    required this.image,
    required this.status, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = _badgeFor(status);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Product image ────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image.isNotEmpty
                ? Image.network(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _PlaceholderImage(),
            )
                : const _PlaceholderImage(),
          ),

          const SizedBox(width: 11),

          // ── Info ─────────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: _textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$duration $durationType",
                      style: const TextStyle(
                        fontSize: 10,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  totalPayment,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _priceColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ── Status badge ─────────────────────────────────────────────────────
          _StatusBadge(config: badge),
        ],
      ),
    );
  }
}

// ── Placeholder image ─────────────────────────────────────────────────────────
class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: _imageBg,
      child: const Icon(
        Icons.checkroom_outlined,
        size: 24,
        color: _imageIcon,
      ),
    );
  }
}

// ── Badge widget ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final _BadgeConfig config;
  const _StatusBadge({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: config.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge config ──────────────────────────────────────────────────────────────
class _BadgeConfig {
  final Color bg;
  final Color dot;
  final Color text;
  final String label;
  const _BadgeConfig({
    required this.bg,
    required this.dot,
    required this.text,
    required this.label,
  });
}

// Amber  — waiting / pending action
const _amber = _BadgeConfig(
  bg: Color(0xFFFAEEDA), dot: Color(0xFFEF9F27), text: Color(0xFF854F0B),
  label: '',
);
// Blue   — in-progress logistics / return in transit
const _blue = _BadgeConfig(
  bg: Color(0xFFE6F1FB), dot: Color(0xFF378ADD), text: Color(0xFF185FA5),
  label: '',
);
// Purple — item in customer's hands (delivered / on rent)
const _purple = _BadgeConfig(
  bg: Color(0xFFEEEDFE), dot: Color(0xFF7F77DD), text: Color(0xFF534AB7),
  label: '',
);
// Green  — positive terminal (paid / returned / completed)
const _green = _BadgeConfig(
  bg: Color(0xFFEAF3DE), dot: Color(0xFF639922), text: Color(0xFF3B6D11),
  label: '',
);
// Red    — negative terminal (expired / failed / cancelled)
const _red = _BadgeConfig(
  bg: Color(0xFFFCEBEB), dot: Color(0xFFE24B4A), text: Color(0xFFA32D2D),
  label: '',
);
// Coral  — warning (late return)
const _coral = _BadgeConfig(
  bg: Color(0xFFFAECE7), dot: Color(0xFFD85A30), text: Color(0xFF993C1D),
  label: '',
);

_BadgeConfig _badgeFor(OrderStatus s) {
  switch (s) {
    case OrderStatus.waitingPayment:
      return _BadgeConfig(bg: _amber.bg, dot: _amber.dot, text: _amber.text,
          label: 'Menunggu Bayar');

    case OrderStatus.paymentExpired:
      return _BadgeConfig(bg: _red.bg, dot: _red.dot, text: _red.text,
          label: 'Kadaluarsa');

    case OrderStatus.paymentFailed:
      return _BadgeConfig(bg: _red.bg, dot: _red.dot, text: _red.text,
          label: 'Bayar Gagal');

    case OrderStatus.paid:
      return _BadgeConfig(bg: _green.bg, dot: _green.dot, text: _green.text,
          label: 'Sudah Dibayar');

    case OrderStatus.waitingConfirmation:
      return _BadgeConfig(bg: _amber.bg, dot: _amber.dot, text: _amber.text,
          label: 'Menunggu Konfirmasi');


    case OrderStatus.processing:
      return _BadgeConfig(bg: _blue.bg, dot: _blue.dot, text: _blue.text,
          label: 'Diproses');

    case OrderStatus.waitingPickup:
      return _BadgeConfig(bg: _blue.bg, dot: _blue.dot, text: _blue.text,
          label: 'Siap Pickup');

    case OrderStatus.onDelivery:
      return _BadgeConfig(bg: _blue.bg, dot: _blue.dot, text: _blue.text,
          label: 'Dikirim');

    case OrderStatus.delivered:
      return _BadgeConfig(bg: _purple.bg, dot: _purple.dot, text: _purple.text,
          label: 'Diterima');


    case OrderStatus.onRent:
      return _BadgeConfig(bg: _purple.bg, dot: _purple.dot, text: _purple.text,
          label: 'Sedang Disewa');

    case OrderStatus.returnPending:
      return _BadgeConfig(bg: _blue.bg, dot: _blue.dot, text: _blue.text,
          label: 'Menunggu Kembali');

    case OrderStatus.returnOnDelivery:
      return _BadgeConfig(bg: _blue.bg, dot: _blue.dot, text: _blue.text,
          label: 'Kembali Dikirim');

    case OrderStatus.returned:
      return _BadgeConfig(bg: _green.bg, dot: _green.dot, text: _green.text,
          label: 'Sudah Kembali');

    case OrderStatus.onInspection:
      return _BadgeConfig(bg: _coral.bg, dot: _coral.dot, text: _coral.text,
          label: 'Dalam Pengecekan');

    case OrderStatus.damageClaim:
      return _BadgeConfig(bg: _coral.bg, dot: _coral.dot, text: _coral.text,
          label: 'Kerusakan Barang');

    case OrderStatus.completed:
      return _BadgeConfig(bg: _green.bg, dot: _green.dot, text: _green.text,
          label: 'Selesai');

    case OrderStatus.cancelled:
      return _BadgeConfig(bg: _red.bg, dot: _red.dot, text: _red.text,
          label: 'Dibatalkan');

    case OrderStatus.lateReturn:
      return _BadgeConfig(bg: _coral.bg, dot: _coral.dot, text: _coral.text,
          label: 'Terlambat Kembali');


  }
}