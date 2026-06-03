import 'package:flutter/material.dart';
import 'package:sewiee/domain/enum/order_status.dart';

// ─── Badge Config ──────────────────────────────────────────────────────────
class BadgeConfig {
  final Color bg, dot, text;
  final String label;
  const BadgeConfig({
    required this.bg,
    required this.dot,
    required this.text,
    required this.label,
  });
}

// ─── Banner Config ─────────────────────────────────────────────────────────
class BannerConfig {
  final Color bg, border, dot, titleColor, subtitleColor;
  final String title, subtitle;
  const BannerConfig({
    required this.bg,
    required this.border,
    required this.dot,
    required this.titleColor,
    required this.subtitleColor,
    required this.title,
    required this.subtitle,
  });
}

// ─── Status Configs ────────────────────────────────────────────────────────
abstract final class OrderStatusConfig {
  static BadgeConfig badge(OrderStatus s) {
    switch (s) {
      case OrderStatus.waitingPayment:
        return const BadgeConfig(
          bg: Color(0xFFFAEEDA),
          dot: Color(0xFFEF9F27),
          text: Color(0xFF854F0B),
          label: 'Menunggu Bayar',
        );
      case OrderStatus.paymentExpired:
      case OrderStatus.paymentFailed:
        return const BadgeConfig(
          bg: Color(0xFFFCEBEB),
          dot: Color(0xFFE24B4A),
          text: Color(0xFFA32D2D),
          label: 'Gagal',
        );
      case OrderStatus.paid:
        return const BadgeConfig(
          bg: Color(0xFFEAF3DE),
          dot: Color(0xFF639922),
          text: Color(0xFF3B6D11),
          label: 'Dibayar',
        );
      case OrderStatus.waitingConfirmation:
      case OrderStatus.processing:
        return const BadgeConfig(
          bg: Color(0xFFE6F1FB),
          dot: Color(0xFF378ADD),
          text: Color(0xFF185FA5),
          label: 'Diproses',
        );
      case OrderStatus.waitingPickup:
        return const BadgeConfig(
          bg: Color(0xFFE6F1FB),
          dot: Color(0xFF378ADD),
          text: Color(0xFF185FA5),
          label: 'Siap Pickup',
        );
      case OrderStatus.onDelivery:
        return const BadgeConfig(
          bg: Color(0xFFE6F1FB),
          dot: Color(0xFF378ADD),
          text: Color(0xFF185FA5),
          label: 'Dikirim',
        );
      case OrderStatus.delivered:
      case OrderStatus.onRent:
        return const BadgeConfig(
          bg: Color(0xFFEEEDFE),
          dot: Color(0xFF7F77DD),
          text: Color(0xFF534AB7),
          label: 'Disewa',
        );
      case OrderStatus.returnPending:
      case OrderStatus.returnOnDelivery:
        return const BadgeConfig(
          bg: Color(0xFFE6F1FB),
          dot: Color(0xFF378ADD),
          text: Color(0xFF185FA5),
          label: 'Pengembalian',
        );
      case OrderStatus.returned:
        return const BadgeConfig(
          bg: Color(0xFFE6F1FB),
          dot: Color(0xFF378ADD),
          text: Color(0xFF185FA5),
          label: 'Dikembalikan',
        );
      case OrderStatus.onInspection:
        return const BadgeConfig(
          bg: Color(0xFFFAECE7),
          dot: Color(0xFFD85A30),
          text: Color(0xFF993C1D),
          label: 'Pengecekan',
        );
      case OrderStatus.damageClaim:
        return const BadgeConfig(
          bg: Color(0xFFFAECE7),
          dot: Color(0xFFD85A30),
          text: Color(0xFF993C1D),
          label: 'Kerusakan Barang',
        );
      case OrderStatus.completed:
        return const BadgeConfig(
          bg: Color(0xFFEAF3DE),
          dot: Color(0xFF639922),
          text: Color(0xFF3B6D11),
          label: 'Selesai',
        );
      case OrderStatus.cancelled:
        return const BadgeConfig(
          bg: Color(0xFFFCEBEB),
          dot: Color(0xFFE24B4A),
          text: Color(0xFFA32D2D),
          label: 'Dibatalkan',
        );
      case OrderStatus.lateReturn:
        return const BadgeConfig(
          bg: Color(0xFFFAECE7),
          dot: Color(0xFFD85A30),
          text: Color(0xFF993C1D),
          label: 'Terlambat',
        );

    }
  }

  static BannerConfig banner(OrderStatus s) {
    switch (s) {
      case OrderStatus.waitingPayment:
        return const BannerConfig(
          bg: Color(0xFFFAEEDA),
          border: Color(0xFFFAC775),
          dot: Color(0xFFEF9F27),
          titleColor: Color(0xFF854F0B),
          subtitleColor: Color(0xFFBA7517),
          title: 'Pembayaran menunggu approve Merchant',
          subtitle: 'Pesanan akan otomatis dibatalkan jika lewat batas waktu',
        );
      case OrderStatus.waitingConfirmation:
      case OrderStatus.processing:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pesanan menunggu konfirmasi',
          subtitle: 'Konfirmasikan jika barang sudah dikirim ke pelanggan',
        );
      case OrderStatus.waitingPickup:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Barang menunggu untuk di-pickup',
          subtitle: 'Pastikan barang sudah siap dikirim ke pelanggan',
        );
      case OrderStatus.onDelivery:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pesanan sedang dalam pengiriman',
          subtitle: 'Tandai setelah barang diterima oleh pelanggan',
        );
      case OrderStatus.delivered:
        return const BannerConfig(
          bg: Color(0xFFEEEDFE),
          border: Color(0xFFCECBF6),
          dot: Color(0xFF7F77DD),
          titleColor: Color(0xFF534AB7),
          subtitleColor: Color(0xFF7F77DD),
          title: 'Barang telah sampai tujuan',
          subtitle: 'Silahkan konfirmasi terlebih dahulu untuk lanjut ke pengecekan',
        );
      case OrderStatus.onInspection:
        return const BannerConfig(
          bg: Color(0xFFFAECE7),
          border: Color(0xFFF5C4B3),
          dot: Color(0xFFD85A30),
          titleColor: Color(0xFF993C1D),
          subtitleColor: Color(0xFFD85A30),
          title: 'Pesanan sedang diinspeksi',
          subtitle: 'Harap tunggu untuk konfirmasi keberlanjutan',
        );
      case OrderStatus.onRent:
        return const BannerConfig(
          bg: Color(0xFFEEEDFE),
          border: Color(0xFFCECBF6),
          dot: Color(0xFF7F77DD),
          titleColor: Color(0xFF534AB7),
          subtitleColor: Color(0xFF7F77DD),
          title: 'Barang sedang dipinjam',
          subtitle: 'Konfirmasi kembali ketika barang dikembalikan',
        );
      case OrderStatus.lateReturn:
        return const BannerConfig(
          bg: Color(0xFFFAECE7),
          border: Color(0xFFF5C4B3),
          dot: Color(0xFFD85A30),
          titleColor: Color(0xFF993C1D),
          subtitleColor: Color(0xFFD85A30),
          title: 'Pengembalian terlambat',
          subtitle: 'Hubungi pelanggan untuk percepatan pengembalian',
        );
      case OrderStatus.returnPending:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pengembalian barang menunggu',
          subtitle: 'Pastikan barang sudah dikembalikan oleh pelanggan',
        );
      case OrderStatus.returnOnDelivery:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pengembalian barang sedang dikirim',
          subtitle: 'Tandai setelah barang diterima di toko',
        );
      case OrderStatus.returned:
        return const BannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Barang dikembalikan',
          subtitle: 'Transaksi selesai dan dana bisa dicairkan',
        );
      case OrderStatus.completed:
        return const BannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Pesanan selesai',
          subtitle: 'Transaksi berhasil dilakukan',
        );
      case OrderStatus.cancelled:
        return const BannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Pesanan dihapus',
          subtitle: 'Pesanan ini sudah tidak aktif',
        );
      default:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Status pesanan',
          subtitle: '',
        );
    }
  }
}

class OrderUtils {
  static String initials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isEmpty) return '-';
    return parts.first
        .substring(0, parts.first.length.clamp(0, 2))
        .toUpperCase();
  }

  static String fmtDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  static DateTime rentalEndDate({
    required DateTime startDate,
    required int totalDuration,
    required String durationType,
  }) {
    final normalized = durationType.trim().toLowerCase();

    if (normalized == 'bulan' || normalized == 'month') {
      return DateTime(
        startDate.year,
        startDate.month + totalDuration,
        startDate.day,
        startDate.hour,
        startDate.minute,
        startDate.second,
        startDate.millisecond,
        startDate.microsecond,
      );
    }

    return startDate.add(Duration(days: totalDuration));
  }

  static String statusUpdateMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.waitingPickup:
        return 'Pesanan dikonfirmasi, menunggu pickup';
      case OrderStatus.onDelivery:
        return 'Pesanan dikonfirmasi, sedang dikirim';
      case OrderStatus.onRent:
        return 'Barang sedang disewa';
      case OrderStatus.delivered:
        return 'Barang ditandai sudah diterima';
      case OrderStatus.returned:
        return 'Barang ditandai sudah dikembalikan';
      case OrderStatus.onInspection:
        return 'Barang masuk pengecekan';
      case OrderStatus.completed:
        return 'Pesanan diselesaikan';
      case OrderStatus.cancelled:
        return 'Pesanan ditolak';
      default:
        return 'Status diperbarui';
    }
  }
}
