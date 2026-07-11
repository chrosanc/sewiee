import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_order/manage_order_screen.dart';
import 'package:sewiee/presentation/merchant/manage/manage_product/manage_product_screen.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';

// ── Color constants ────────────────────────────────────────────────────────────
const _bg = Color(0xFFF5F5F0);
const _surface = Color(0xFFFFFFFF);
const _border = Color(0xFFE8E6E0);
const _divider = Color(0xFFEFEDE8);
const _textPrimary = Color(0xFF1A1A18);
const _textSecondary = Color(0xFF888780);

// Amber
const _amberBg = Color(0xFFFAEEDA);
const _amberMid = Color(0xFFFAC775);
const _amberStrong = Color(0xFFBA7517);
const _amberDark = Color(0xFF854F0B);
const _amberDeeper = Color(0xFF633806);
const _amberDarkest = Color(0xFF412402);

// Teal
const _tealBg = Color(0xFFE1F5EE);
const _tealStrong = Color(0xFF0F6E56);

// Blue
const _blueBg = Color(0xFFE6F1FB);
const _blueStrong = Color(0xFF185FA5);

// Coral
const _coralBg = Color(0xFFFAECE7);
const _coralStrong = Color(0xFF993C1D);

// Green
const _greenBg = Color(0xFFEAF3DE);
const _greenStrong = Color(0xFF3B6D11);

// Gray
const _grayBg = Color(0xFFF1EFE8);
const _grayStrong = Color(0xFF5F5E5A);

class ManageMerchantScreen extends StatefulWidget {
  const ManageMerchantScreen({super.key});

  @override
  State<ManageMerchantScreen> createState() => _ManageMerchantScreenState();
}

class _ManageMerchantScreenState extends State<ManageMerchantScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ManageMerchantViewmodel>(context);
    final orderVm = Provider.of<OrderViewmodel>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: _surface,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.5),
                child: Container(height: 0.5, color: _border),
              ),
              title: Column(
                children: const [
                  Text(
                    'Kelola Toko',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    'Dashboard Penjual',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _StoreAvatar(
                    initials: _initials(vm.userModel?.storeName ?? 'Toko Saya'),
                  ),
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Store Banner ─────────────────────────────────────────
                  _StoreBanner(
                    storeName: vm.userModel?.storeName ?? 'Nama Toko',
                    storeHandle:
                        vm.userModel?.storeUsername ?? '@username_toko',
                  ),
                  const SizedBox(height: 10),

                  // ── Stats Card ──────────────────────────────────────────
                  _SectionCard(
                    iconData: Fa6Solid.chart_bar,
                    iconBg: _amberBg,
                    iconColor: _amberDark,
                    title: 'Ringkasan',
                    actionLabel: 'Detail',
                    onAction: () {},
                    child: const _StatsRow(),
                  ),
                  const SizedBox(height: 10),

                  // ── Products Card ───────────────────────────────────────
                  _SectionCard(
                    iconData: Fa6Solid.box,
                    iconBg: _coralBg,
                    iconColor: _coralStrong,
                    title: 'Produk Kamu',
                    actionLabel: 'Kelola',
                    onAction: () async {
                      final ProductModel? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManageProductScreen(),
                        ),
                      );
                      if (result is ProductModel) {
                        vm.getProductByCurrentUser(context);
                      }
                    },
                    child: vm.listProduct.isEmpty
                        ? const _EmptyState(message: 'Belum ada produk')
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: vm.listProduct.length.clamp(0, 5),
                            separatorBuilder: (_, __) => const Divider(
                              height: 0.5,
                              color: _divider,
                              indent: 14,
                              endIndent: 14,
                            ),
                            itemBuilder: (context, index) {
                              final item = vm.listProduct[index];
                              return _ProductRow(
                                image: item.images.first,
                                name: item.productName,
                                category: item.categoryName,
                                price: item.price,
                                active: item.active,
                                stock: item.stock,
                                durationType: item.durationType,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),

                  // ── Orders Card ─────────────────────────────────────────
                  // ── Orders Card ─────────────────────────────────────────
                  _SectionCard(
                    iconData: Fa6Solid.clipboard_list,
                    iconBg: _tealBg,
                    iconColor: _tealStrong,
                    title: 'Pesanan Toko',
                    actionLabel: 'Semua',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ManageOrderScreen()),
                      );
                    },
                    child: StreamBuilder<List<OrderModel>>(
                      stream: orderVm.streamOrderByOwnerId(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _tealStrong,
                                ),
                              ),
                            ),
                          );
                        }

                        final orders = (snapshot.data ?? []).take(5).toList();

                        if (orders.isEmpty) {
                          return const _EmptyState(
                            message: 'Belum ada Pesanan',
                          );
                        }

                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orders.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 0.5,
                            color: _divider,
                            indent: 14,
                            endIndent: 14,
                          ),
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _OrderRow(order: order);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}

// ── Order Row ─────────────────────────────────────────────────────────────────
class _OrderRow extends StatelessWidget {
  final OrderModel order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Thumbnail produk
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color(0xFFF5F4F0),
                  child: Image.network(
                    order.productSnapshot.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      size: 18,
                      color: _textSecondary,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productSnapshot.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#${order.orderNumber}',
                    style: const TextStyle(fontSize: 10, color: _textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 5),

          // Harga + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils().toRupiah(order.payment.amount.totalPayment),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _amberStrong,
                ),
              ),
              const SizedBox(height: 4),
              _OrderStatusBadge(status: order.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      OrderStatus.waitingConfirmation => (
        _amberBg,
        _amberDark,
        "Butuh Konfirmasi",
      ),
      OrderStatus.waitingPayment => (_amberBg, _amberDark, 'Belum Bayar'),
      OrderStatus.onDelivery => (_blueBg, _blueStrong, 'Dikirim'),
      OrderStatus.waitingPickup => (_tealBg, _tealStrong, 'Ambil'),
      OrderStatus.onRent => (_tealBg, _tealStrong, 'Disewa'),
      OrderStatus.returnOnDelivery => (_blueBg, _blueStrong, 'Kembali'),
      OrderStatus.onInspection => (_amberBg, _amberDark, 'Inspeksi'),
      OrderStatus.damageClaim => (_coralBg, _coralStrong, 'Klaim'),
      OrderStatus.completed => (_greenBg, _greenStrong, 'Selesai'),
      _ => (_grayBg, _grayStrong, status.value),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}

// ── Store Avatar ──────────────────────────────────────────────────────────────
class _StoreAvatar extends StatelessWidget {
  final String initials;
  const _StoreAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(color: _amberMid, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _amberDeeper,
        ),
      ),
    );
  }
}

// ── Store Banner ──────────────────────────────────────────────────────────────
class _StoreBanner extends StatelessWidget {
  final String storeName;
  final String storeHandle;
  const _StoreBanner({required this.storeName, required this.storeHandle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _amberMid,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _amberDeeper,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              storeName.isNotEmpty ? storeName[0].toUpperCase() : 'T',
              style: const TextStyle(
                color: _amberBg,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _amberDarkest,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  storeHandle,
                  style: const TextStyle(fontSize: 11, color: _amberDark),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _amberDeeper.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 12, color: _amberDeeper),
                  SizedBox(width: 4),
                  Text(
                    'Ubah',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _amberDeeper,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String iconData;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget child;

  const _SectionCard({
    required this.iconData,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Iconify(iconData, size: 14, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onAction,
                  child: Row(
                    children: [
                      Text(
                        actionLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _textSecondary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 13,
                        color: _textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, color: _divider),
          child,
        ],
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: const [
          _StatItem(
            label: 'Keuntungan',
            value: 'Rp 0rb',
            valueColor: _amberStrong,
          ),
          VerticalDivider(width: 0.5, color: _divider),
          _StatItem(label: 'Produk', value: '0', valueColor: _tealStrong),
          VerticalDivider(width: 0.5, color: _divider),
          _StatItem(label: 'Pesanan', value: '0', valueColor: _blueStrong),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: _textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product Row ───────────────────────────────────────────────────────────────
class _ProductRow extends StatelessWidget {
  final String name;
  final String category;
  final int price;
  final bool active;
  final int stock;
  final String durationType;
  final String image;

  const _ProductRow({
    required this.name,
    required this.category,
    required this.price,
    required this.active,
    required this.stock,
    required this.durationType,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFF5F4F0)),
                  child: Image.network(image, fit: BoxFit.cover),
                ),
              ),
              Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$category · $durationType',
                    style: const TextStyle(fontSize: 10, color: _textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),

          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils().toRupiah(price),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _amberStrong,
                ),
              ),
              const SizedBox(height: 4),
              _StatusBadge(active: active, stock: stock),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(int p) {
    if (p >= 1000000) return '${(p / 1000000).toStringAsFixed(1)}jt';
    if (p >= 1000) return '${(p / 1000).toStringAsFixed(0)}rb';
    return p.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  final int stock;
  const _StatusBadge({required this.active, required this.stock});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    if (!active || stock == 0) {
      bg = _amberBg;
      fg = _amberDark;
      label = stock == 0 ? 'Habis' : 'Nonaktif';
    } else {
      bg = _greenBg;
      fg = _greenStrong;
      label = 'Aktif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 28,
            color: Color(0xFFD3D1C7),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: _textSecondary),
          ),
        ],
      ),
    );
  }
}
