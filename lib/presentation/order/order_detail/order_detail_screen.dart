import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/checkout/payment/midtrans_snap_screen.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_receipt_sheet.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_return_receipt_sheet.dart';
import 'package:sewiee/presentation/widget/order_detail/order_detail_bottom_bar.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late OrderViewmodel vm;

  // ── Design tokens ────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF7F6F3);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF1A1A2E);
  static const _inkSub = Color(0xFF6B7280);
  static const _accent = Color(0xFFE8572A); // burnt-orange
  static const _accentSoft = Color(0xFFFDF0EB);
  static const _success = Color(0xFF22C55E);
  static const _successSoft = Color(0xFFEFFDF5);
  static const _border = Color(0xFFECEBE8);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm = context.read<OrderViewmodel>();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel>(
      stream: vm.streamOrder(),

      builder: (context, snapshot) {
        // =========================
        // LOADING
        // =========================
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // =========================
        // ERROR
        // =========================
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Terjadi kesalahan: ${snapshot.error}')),
          );
        }

        // =========================
        // EMPTY
        // =========================
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Pesanan tidak ditemukan')),
          );
        }

        final order = snapshot.data!;

        return Scaffold(
          backgroundColor: _bg,

          appBar: _buildAppBar(context),

          // =========================
          // BOTTOM BAR
          // =========================
          bottomNavigationBar: RenterOrderBottomBar(
            status: order.status,

            deliveryMethod: DeliveryMethodX.fromString(
              order.shipping.deliveryMethod,
            ),

            isLoading: vm.isLoading,

            // =========================
            // BAYAR
            // =========================
            onPay: () async {},

            // =========================
            // CANCEL
            // =========================
            onCancel: () async {},

            // =========================
            // BARANG SAMPAI
            // =========================
            onConfirmArrived: () async {
              await vm.updateDeliveredStatus();
            },

            // =========================
            // MULAI SEWA
            // =========================
            onStartRent: () async {
              await vm.updateRenterOrderStatus(
                orderId: order.id,
                status: OrderStatus.onRent,
              );
            },

            // =========================
            // PENGEMBALIAN
            // =========================
            onSubmitReturn: () async {
              final isExpedition =
                  order.shipping.returnMethod == 'expedition_return';

              // =========================
              // RETURN VIA EXPEDITION
              // =========================
              if (isExpedition) {
                final receiptNumberController = TextEditingController();
                final courierNameController = TextEditingController();

                final receipt = await showReturnReceiptNumberSheet(
                  context,
                  receiptNumberController: receiptNumberController,
                  courierNameController: courierNameController,
                );

                if (receipt == null) return;

                await vm.submitReturnByExpedition(
                  receiptNumber: receipt['receipt_number']!,
                  courierName: receipt['courier_name']!,
                );

                return;
              }

              // =========================
              // PICKUP RETURN
              // =========================
              await vm.updateRenterOrderStatus(
                orderId: order.id,
                status: OrderStatus.returnOnDelivery,
              );
            },

            // =========================
            // TRACK RETURN
            // =========================
            onTrackReturn: () {},

            // =========================
            // PAY PENALTY
            // =========================
            onPayPenalty: () async {

              final vm = context.read<OrderViewmodel>();

              final response = await vm.payDamagePenalty(
                order
              );

              final snapToken = response['token'];

              if (snapToken == null) return;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MidtransSnapScreen(
                    orderId: order.id,
                    snapToken: snapToken,
                  ),
                ),
              );
            },

            // =========================
            // HELP
            // =========================
            onHelp: () {},
          ),

          // =========================
          // BODY
          // =========================
          body: FadeTransition(
            opacity: _fadeAnimation,

            child: SlideTransition(
              position: _slideAnimation,

              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),

                child: Column(
                  children: [
                    _StatusBannerCard(status: order.status, model: order),

                    _buildOrderMeta(order),

                    const SizedBox(height: 12),

                    _buildStoreCard(order),

                    const SizedBox(height: 12),

                    _buildProductCard(order),

                    const SizedBox(height: 12),

                    _buildShippingCard(order),

                    const SizedBox(height: 12),

                    _buildReturnCard(order),

                    const SizedBox(height: 12),

                    _buildPaymentCard(order),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: _border,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        color: _ink,
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Detail Pesanan',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _ink,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz_rounded, size: 22),
          color: _ink,
          onPressed: () {},
        ),
      ],
    );
  }

  // ── Status Banner ────────────────────────────────────────────────────────────

  // ── Order Meta ───────────────────────────────────────────────────────────────
  Widget _buildOrderMeta(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Status Pesanan', Icons.receipt_long_outlined),
          const SizedBox(height: 16),
          _metaRow('Kode Pesanan', order!.orderNumber, copyable: true),
          const SizedBox(height: 10),
          _metaRow(
            'Tanggal Pembayaran',
            DateFormat.formatDateTimeWIB(order.payment.paidAt!),
          ),
        ],
      ),
    );
  }

  // ── Store Card ─────────────────────────────────────────────────────────────
  Widget _buildStoreCard(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Detail Toko', Icons.store_outlined),
          const SizedBox(height: 16),
          _metaRow('Nama Toko', order?.ownerSnapshot.storeName ?? ''),
          const SizedBox(height: 10),
          _metaRow(
            'Nomor Handphone Toko',
            order?.ownerSnapshot.phoneNumber ?? '',
          ),
        ],
      ),
    );
  }

  // ── Product Card ─────────────────────────────────────────────────────────────
  Widget _buildProductCard(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Detail Produk', Icons.shopping_bag_outlined),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // Product image placeholder
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    order!.productSnapshot.image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productSnapshot.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: _ink,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            order.rental.totalDuration.toString(),
                            style: TextStyle(fontSize: 11, color: _inkSub),
                          ),
                          Gap(5),
                          Text(
                            order.productSnapshot.durationType,
                            style: TextStyle(fontSize: 11, color: _inkSub),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${CurrencyUtils().toRupiah(order.productSnapshot.price)} / ${order.productSnapshot.durationType}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: _accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _inkSub,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Shipping Card ────────────────────────────────────────────────────────────
  Widget _buildShippingCard(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Info Pengiriman', Icons.local_shipping_outlined),

          const SizedBox(height: 16),

          // =========================
          // METODE PENGIRIMAN
          // =========================
          Row(
            children: [
              Expanded(
                child: _infoTile(
                  icon: Icons.local_shipping_outlined,
                  label: 'Metode Pengiriman',
                  value: DeliveryMethodX.fromString(
                    order!.shipping.deliveryMethod,
                  ).label,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          if (order.shipping.deliveryMethod == 'expedition') ...[
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.numbers_rounded,
              label: 'Nomor Resi',
              value:
                  order.shipping.deliveryTracking?.receiptNumber ??
                  'Belum dikirim',
              trailing: _chipLabel(
                order.shipping.deliveryTracking?.courierName ?? '',
              ),
            ),
          ],

          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengiriman',
            value: order.address.renter.fullAddress!,
          ),
        ],
      ),
    );
  }

  // ── Return Card ──────────────────────────────────────────────────────────────
  Widget _buildReturnCard(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Info Pengembalian', Icons.local_shipping_outlined),

          const SizedBox(height: 16),

          // =========================
          // METODE PENGEMBALIAN
          // =========================
          Row(
            children: [
              Expanded(
                child: _infoTile(
                  icon: Icons.local_shipping_outlined,
                  label: 'Metode Pengembalian',
                  value: DeliveryMethodX.fromString(
                    order!.shipping.returnMethod,
                  ).label,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          if (order.shipping.returnMethod == 'expedition_return') ...[
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.numbers_rounded,
              label: 'Nomor Resi',
              value:
                  order.shipping.returnTracking?.receiptNumber ??
                  'Belum melakukan pengembalian',
              trailing: order.shipping.returnTracking?.courierName != null
                  ? _chipLabel(order.shipping.returnTracking!.courierName)
                  : null,
            ),
          ],

          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengembalian',
            value: order.address.renter.fullAddress!,
          ),
        ],
      ),
    );
  }

  // ── Payment Card ─────────────────────────────────────────────────────────────
  Widget _buildPaymentCard(OrderModel order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Rincian Pembayaran', Icons.payment_outlined),
          const SizedBox(height: 16),
          _metaRow('Metode Pembayaran', order!.payment.paymentMethod.name),
          const SizedBox(height: 10),
          _metaRow(
            'Total Harga (${order.rental.totalDuration} ${order.productSnapshot.durationType})',
            CurrencyUtils().toRupiah(
              order.productSnapshot.price * order.rental.totalDuration,
            ),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Deposit Jaminan',
            CurrencyUtils().toRupiah(order.payment.amount.depositAmount),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Ongkos Kirim',
            CurrencyUtils().toRupiah(order.payment.amount.deliveryFee),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Biaya Layanan',
            CurrencyUtils().toRupiah(order.payment.amount.serviceFee),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Biaya Jasa Aplikasi',
            CurrencyUtils().toRupiah(order.payment.amount.applicationFee),
          ),

          // const SizedBox(height: 10),
          // _metaRow('Diskon', '- Rp 0', valueColor: _success),
          const SizedBox(height: 14),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: _ink,
                ),
              ),
              Text(
                CurrencyUtils().toRupiah(order.payment.amount.totalPayment),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: _accent,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Action Button ────────────────────────────────────────────────────────────

  // ── Reusable helpers ─────────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: _ink.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _accentSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _accent),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _ink,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _metaRow(
    String label,
    String value, {
    bool copyable = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: _inkSub)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? _ink,
          ),
        ),
        if (copyable) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.copy_rounded, size: 14, color: _inkSub),
          ),
        ],
      ],
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: _inkSub),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: _inkSub)),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _chipLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _successSoft,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _success.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _success,
        ),
      ),
    );
  }
}

class _StatusBannerCard extends StatelessWidget {
  final OrderStatus status;
  final OrderModel? model;

  const _StatusBannerCard({required this.status, this.model});

  @override
  Widget build(BuildContext context) {
    final cfg = RenterBannerConfig.banner(status, model);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
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
      ),
    );
  }
}
