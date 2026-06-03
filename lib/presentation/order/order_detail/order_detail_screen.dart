import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';

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
  static const _accent = Color(0xFFE8572A);   // burnt-orange
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
                _buildStatusBanner(),
                const SizedBox(height: 12),
                _buildOrderMeta(),
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
  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF2D2D52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _ink.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon pill
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sedang Dikirim',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimasi tiba 3–5 hari kerja',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _success,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Aktif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Order Meta ───────────────────────────────────────────────────────────────
  Widget _buildOrderMeta() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Status Pesanan', Icons.receipt_long_outlined),
          const SizedBox(height: 16),
          _stepper(),
          const SizedBox(height: 20),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 16),
          _metaRow('Kode Pesanan', 'INV-1021032-2130', copyable: true),
          const SizedBox(height: 10),
          _metaRow('Tanggal Pembayaran', '05 April 2026, 17:05 WIB'),
        ],
      ),
    );
  }

  Widget _stepper() {
    final steps = ['Dikonfirmasi', 'Diproses', 'Dikirim','Dikembalikan', 'Selesai'];
    const current = 0; // 0-indexed: Dikirim

    return Row(
      children: List.generate(steps.length, (i) {
        final isDone = i <= current;
        final isActive = i == current;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (i > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i <= current ? _accent : _border,
                      ),
                    ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? _accent : _border,
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                          : null,
                    ),
                    child: Icon(
                      isDone ? Icons.check_rounded : Icons.circle,
                      size: isDone ? 16 : 8,
                      color: isDone ? Colors.white : _inkSub,
                    ),
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i < current ? _accent : _border,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Transform.translate(
                offset: Offset(
                  i == 0
                      ? -4
                      : i == steps.length - 1
                      ? 16
                      : 0,
                  0,
                ),
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isDone ? _accent : _inkSub,
                  ),
                ),
              )
            ],
          ),
        );
      }),
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
                    color: const Color(0xFFF0EEE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.checkroom_rounded,
                    color: _inkSub,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kemeja Batik Premium Solo',
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
                      Text(
                        'Ukuran: L · Warna: Cokelat Sogan',
                        style: TextStyle(
                          fontSize: 11,
                          color: _inkSub,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Rp 1.000.000',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: _accent,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _accentSoft,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'x1',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: _inkSub, size: 20),
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
          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengiriman',
            value: 'Jl. Raya Beji, Karangsalam, Banyumas\nJawa Tengah 53152',
          ),
          const SizedBox(height: 12),
          _infoTile(
            icon: Icons.numbers_rounded,
            label: 'Nomor Resi',
            value: 'JNE-00192837465',
            trailing: _chipLabel('JNE REG'),
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
          _sectionTitle('Info Pengembalian', Icons.sync_alt_rounded),
          const SizedBox(height: 16),
          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Pengembalian',
            value: 'Jl. Raya Beji, Karangsalam, Banyumas\nJawa Tengah 53152',
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
          _metaRow('Metode Pembayaran', 'Transfer BCA'),
          const SizedBox(height: 10),
          _metaRow('Harga Barang', 'Rp 1.000.000'),
          const SizedBox(height: 10),
          _metaRow('Ongkos Kirim', 'Rp 25.000'),
          const SizedBox(height: 10),
          _metaRow('Diskon', '- Rp 0', valueColor: _success),
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
                'Rp 1.025.000',
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

  Widget _metaRow(String label, String value,
      {bool copyable = false, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _inkSub),
        ),
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
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: _inkSub),
              ),
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