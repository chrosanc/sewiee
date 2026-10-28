import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/data/model/order_model.dart';
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

  static BannerConfig banner(OrderStatus s, OrderModel? orderData) {
    switch (s) {
      case OrderStatus.waitingPayment:
        return const BannerConfig(
          bg: Color(0xFFFAEEDA),
          border: Color(0xFFFAC775),
          dot: Color(0xFFEF9F27),
          titleColor: Color(0xFF854F0B),
          subtitleColor: Color(0xFFBA7517),
          title: 'Menunggu pembayaran',
          subtitle: 'Verifikasi pembayaran pelanggan sebelum memproses pesanan',
        );
      case OrderStatus.waitingConfirmation:
      case OrderStatus.processing:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pesanan masuk',
          subtitle: 'Siapkan barang dan verifikasi detail pesanan',
        );
      case OrderStatus.waitingPickup:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Menunggu pengambilan',
          subtitle: 'Pastikan barang sudah siap dan sesuai pesanan',
        );
      case OrderStatus.onDelivery:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pesanan dalam pengiriman',
          subtitle: 'Pantau status pengiriman hingga pelanggan menerima barang',
        );
      case OrderStatus.delivered:
        return const BannerConfig(
          bg: Color(0xFFEEEDFE),
          border: Color(0xFFCECBF6),
          dot: Color(0xFF7F77DD),
          titleColor: Color(0xFF534AB7),
          subtitleColor: Color(0xFF7F77DD),
          title: 'Pesanan diterima pelanggan',
          subtitle: 'Konfirmasi penerimaan untuk melanjutkan proses selanjutnya',
        );
      case OrderStatus.onInspection:
        return const BannerConfig(
          bg: Color(0xFFFAECE7),
          border: Color(0xFFF5C4B3),
          dot: Color(0xFFD85A30),
          titleColor: Color(0xFF993C1D),
          subtitleColor: Color(0xFFD85A30),
          title: 'Pengecekan barang',
          subtitle: 'Periksa kondisi barang sebelum memberikan persetujuan',
        );
      case OrderStatus.damageClaim:
        return const BannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Kerusakan barang',
          subtitle: 'Permintaan biaya kerusakan barang dikirim.',
        );

      case OrderStatus.onRent:
        return BannerConfig(
          bg: Color(0xFFEEEDFE),
          border: Color(0xFFCECBF6),
          dot: Color(0xFF7F77DD),
          titleColor: Color(0xFF534AB7),
          subtitleColor: Color(0xFF7F77DD),
          title: 'Sedang dipinjam pelanggan',
          subtitle: 'Tanggal sewa: ${orderData?.rental.startDate ?? '-'}',
        );
      case OrderStatus.lateReturn:
        return const BannerConfig(
          bg: Color(0xFFFAECE7),
          border: Color(0xFFF5C4B3),
          dot: Color(0xFFD85A30),
          titleColor: Color(0xFF993C1D),
          subtitleColor: Color(0xFFD85A30),
          title: 'Pengembalian terlambat',
          subtitle: 'Hubungi pelanggan untuk percepatan pengembalian barang',
        );
      case OrderStatus.returnPending:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Menunggu pengembalian',
          subtitle: 'Pastikan barang dikembalikan sesuai kondisi pesanan',
        );
      case OrderStatus.returnOnDelivery:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pengembalian dalam perjalanan',
          subtitle: 'Pantau status pengembalian hingga barang tiba di toko',
        );
      case OrderStatus.returned:
        return const BannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Barang dikembalikan',
          subtitle: 'Transaksi selesai.',
        );
      case OrderStatus.completed:
        return const BannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Pesanan selesai',
          subtitle: 'Transaksi berhasil dan ditutup.',
        );
      case OrderStatus.cancelled:
        return const BannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Pesanan dibatalkan',
          subtitle: 'Pesanan tidak dilanjutkan.',
        );
      default:
        return const BannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Status pesanan',
          subtitle: 'Periksa detail pesanan untuk tindakan lebih lanjut',
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
      case OrderStatus.damageClaim:
        return 'Barang keadaan rusak';
      case OrderStatus.completed:
        return 'Pesanan diselesaikan';
      case OrderStatus.cancelled:
        return 'Pesanan ditolak';
      default:
        return 'Status diperbarui';
    }
  }
}

class RenterBannerConfig {
  final Color bg, border, dot, titleColor, subtitleColor;
  final String title, subtitle;

  const RenterBannerConfig({
    required this.bg,
    required this.border,
    required this.dot,
    required this.titleColor,
    required this.subtitleColor,
    required this.title,
    required this.subtitle,
  });

  static RenterBannerConfig banner(OrderStatus s, OrderModel? orderData) {
    switch (s) {

    /// =========================
    /// WAITING PAYMENT
    /// =========================
      case OrderStatus.waitingPayment:
        return const RenterBannerConfig(
          bg: Color(0xFFFAEEDA),
          border: Color(0xFFFAC775),
          dot: Color(0xFFEF9F27),
          titleColor: Color(0xFF854F0B),
          subtitleColor: Color(0xFFBA7517),
          title: 'Selesaikan pembayaran',
          subtitle: 'Pesanan kamu belum aktif sampai pembayaran berhasil',
        );

    /// =========================
    /// PAYMENT FAILED / EXPIRED
    /// =========================
      case OrderStatus.paymentFailed:
      case OrderStatus.paymentExpired:
        return const RenterBannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Pembayaran gagal',
          subtitle: 'Silakan lakukan pembayaran ulang untuk melanjutkan',
        );

    /// =========================
    /// PAID
    /// =========================
      case OrderStatus.paid:
        return const RenterBannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Pembayaran berhasil',
          subtitle: 'Pesanan kamu sedang diproses oleh toko',
        );

    /// =========================
    /// PROCESSING
    /// =========================
      case OrderStatus.waitingConfirmation:
      case OrderStatus.processing:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pesanan diproses',
          subtitle: 'Merchant sedang menyiapkan barang kamu',
        );

    /// =========================
    /// WAITING PICKUP
    /// =========================
      case OrderStatus.waitingPickup:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Barang siap diambil',
          subtitle: 'Silakan ambil barang sewaan anda',
        );

    /// =========================
    /// ON DELIVERY
    /// =========================
      case OrderStatus.onDelivery:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Dalam perjalanan',
          subtitle: 'Pesanan sedang menuju lokasi kamu',
        );

    /// =========================
    /// DELIVERED
    /// =========================
      case OrderStatus.delivered:
        return const RenterBannerConfig(
          bg: Color(0xFFEEEDFE),
          border: Color(0xFFCECBF6),
          dot: Color(0xFF7F77DD),
          titleColor: Color(0xFF534AB7),
          subtitleColor: Color(0xFF7F77DD),
          title: 'Barang sudah diterima',
          subtitle: 'Kamu bisa mulai menggunakan barang sewaan',
        );

    /// =========================
    /// ON RENT
    /// =========================
      case OrderStatus.onRent:
        return RenterBannerConfig(
          bg: const Color(0xFFEEEDFE),
          border: const Color(0xFFCECBF6),
          dot: const Color(0xFF7F77DD),
          titleColor: const Color(0xFF534AB7),
          subtitleColor: const Color(0xFF7F77DD),
          title: 'Sedang disewa',
          subtitle:
          'Waktu : ${orderData!.rental.totalDuration} ${orderData.productSnapshot.durationType} • ${DateFormat.formatDateOnly(orderData!.rental.startDate!)} - ${DateFormat.formatDateOnly(orderData.rental.endDate!)}',
        );

    /// =========================
    /// RETURN FLOW
    /// =========================
      case OrderStatus.returnPending:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Menunggu pengembalian',
          subtitle: 'Persiapkan barang untuk dikembalikan',
        );

      case OrderStatus.returnOnDelivery:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Pengembalian dalam proses',
          subtitle: 'Barang sedang dikirim kembali ke toko',
        );

      case OrderStatus.returned:
        return const RenterBannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Barang sudah dikembalikan',
          subtitle: 'Terima kasih sudah mengembalikan tepat waktu',
        );

    /// =========================
    /// INSPECTION / DAMAGE
    /// =========================
      case OrderStatus.onInspection:
        return const RenterBannerConfig(
          bg: Color(0xFFFAECE7),
          border: Color(0xFFF5C4B3),
          dot: Color(0xFFD85A30),
          titleColor: Color(0xFF993C1D),
          subtitleColor: Color(0xFFD85A30),
          title: 'Proses pengecekan',
          subtitle: 'Barang sedang diperiksa oleh toko',
        );

      case OrderStatus.damageClaim:
        return RenterBannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Klaim kerusakan',
          subtitle: 'Denda : ${CurrencyUtils().toRupiah(orderData!.rental.brokenFine!)}',
        );

    /// =========================
    /// COMPLETED
    /// =========================
      case OrderStatus.completed:
        return const RenterBannerConfig(
          bg: Color(0xFFEAF3DE),
          border: Color(0xFFC0DD97),
          dot: Color(0xFF639922),
          titleColor: Color(0xFF3B6D11),
          subtitleColor: Color(0xFF639922),
          title: 'Selesai',
          subtitle: 'Transaksi kamu telah selesai',
        );

    /// =========================
    /// CANCELLED
    /// =========================
      case OrderStatus.cancelled:
        return const RenterBannerConfig(
          bg: Color(0xFFFCEBEB),
          border: Color(0xFFF7C1C1),
          dot: Color(0xFFE24B4A),
          titleColor: Color(0xFFA32D2D),
          subtitleColor: Color(0xFFE24B4A),
          title: 'Pesanan dibatalkan',
          subtitle: 'Pesanan tidak dapat dilanjutkan',
        );

    /// =========================
    /// DEFAULT
    /// =========================
      default:
        return const RenterBannerConfig(
          bg: Color(0xFFE6F1FB),
          border: Color(0xFFB5D4F4),
          dot: Color(0xFF378ADD),
          titleColor: Color(0xFF185FA5),
          subtitleColor: Color(0xFF378ADD),
          title: 'Status pesanan',
          subtitle: 'Silakan cek detail pesanan kamu',
        );
    }
  }
}