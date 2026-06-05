import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel orderData;

  const OrderDetailScreen({super.key, required this.orderData});

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
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                _StatusBannerCard(status: widget.orderData.status),
                _buildOrderMeta(),
                const SizedBox(height: 12),
                _buildStoreCard(),
                const SizedBox(height: 12),
                _buildProductCard(),
                const SizedBox(height: 12),
                _buildShippingCard(),
                const SizedBox(height: 12),
                _buildReturnCard(),
                const SizedBox(height: 12),
                _buildPaymentCard(),
                const SizedBox(height: 20),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
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
  Widget _buildOrderMeta() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Status Pesanan', Icons.receipt_long_outlined),
          const SizedBox(height: 16),
          _metaRow(
            'Kode Pesanan',
            widget.orderData.orderNumber,
            copyable: true,
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Tanggal Pembayaran',
            DateFormat.formatDateTimeWIB(widget.orderData.payment.paidAt!),
          ),
        ],
      ),
    );
  }
  // ── Store Card ─────────────────────────────────────────────────────────────
  Widget _buildStoreCard(){
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Detail Toko', Icons.store_outlined),
          const SizedBox(height: 16),
          _metaRow(
            'Nama Toko',
            widget.orderData.renterSnapshot.name,
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Nomor Handphone Toko',
            '',
          ),
        ],
      ),
    );
  }

  // ── Product Card ─────────────────────────────────────────────────────────────
  Widget _buildProductCard() {
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
                    widget.orderData.productSnapshot.image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orderData.productSnapshot.name,
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
                            widget.orderData.rental.totalDuration.toString(),
                            style: TextStyle(fontSize: 11, color: _inkSub),
                          ),
                          Gap(5),
                          Text(
                            widget.orderData.productSnapshot.durationType,
                            style: TextStyle(fontSize: 11, color: _inkSub),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${CurrencyUtils().toRupiah(widget.orderData.productSnapshot.price)} / ${widget.orderData.productSnapshot.durationType}',
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
  Widget _buildShippingCard() {
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
                    widget.orderData.shipping.deliveryMethod,
                  ).label,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          if (widget.orderData.shipping.deliveryMethod == 'expedition') ...[
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.numbers_rounded,
              label: 'Nomor Resi',
              value:
                  widget.orderData.shipping.deliveryTracking?.receiptNumber ??
                  '',
              trailing: _chipLabel(
                widget.orderData.shipping.deliveryTracking?.courierName ?? '',
              ),
            ),
          ],

          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengiriman',
            value: widget.orderData.address.renter.fullAddress!,
          ),
        ],
      ),
    );
  }

  // ── Return Card ──────────────────────────────────────────────────────────────
  Widget _buildReturnCard() {
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
                    widget.orderData.shipping.returnMethod,
                  ).label,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          if (widget.orderData.shipping.returnMethod ==
              'expedition_return') ...[
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.numbers_rounded,
              label: 'Nomor Resi',
              value:
                  widget.orderData.shipping.returnTracking?.receiptNumber ?? '',
              trailing: _chipLabel(
                widget.orderData.shipping.returnTracking?.courierName ?? '',
              ),
            ),
          ],

          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengembalian',
            value: widget.orderData.address.renter.fullAddress!,
          ),
        ],
      ),
    );
  }

  // ── Payment Card ─────────────────────────────────────────────────────────────
  Widget _buildPaymentCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Rincian Pembayaran', Icons.payment_outlined),
          const SizedBox(height: 16),
          _metaRow(
            'Metode Pembayaran',
            widget.orderData.payment.paymentMethod.name,
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Total Harga (${widget.orderData.rental.totalDuration} ${widget.orderData.productSnapshot.durationType})',
            CurrencyUtils().toRupiah(
              widget.orderData.productSnapshot.price *
                  widget.orderData.rental.totalDuration,
            ),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Deposit Jaminan',
            CurrencyUtils().toRupiah(
              widget.orderData.payment.amount.depositAmount,
            ),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Ongkos Kirim',
            CurrencyUtils().toRupiah(
              widget.orderData.payment.amount.deliveryFee,
            ),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Biaya Layanan',
            CurrencyUtils().toRupiah(
              widget.orderData.payment.amount.serviceFee,
            ),
          ),
          const SizedBox(height: 10),
          _metaRow(
            'Biaya Jasa Aplikasi',
            CurrencyUtils().toRupiah(
              widget.orderData.payment.amount.applicationFee,
            ),
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
                CurrencyUtils().toRupiah(widget.orderData.payment.amount.totalPayment),
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
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.support_agent_rounded, size: 20),
          label: const Text(
            'Hubungi Penjual',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

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
