import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/presentation/main/main_screen.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final OrderModel orderModel;

  const PaymentSuccessScreen({
    super.key,
    required this.orderModel,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final vm = Provider.of<OrderViewmodel>(context, listen: false);
    final orderModel = widget.orderModel;
    final primaryColor = themeData.primaryColor;

    final formattedDate =
        '${orderModel.createdAt.day.toString().padLeft(2, '0')}/'
        '${orderModel.createdAt.month.toString().padLeft(2, '0')}/'
        '${orderModel.createdAt.year}';
    final formattedTime =
        '${orderModel.createdAt.hour.toString().padLeft(2, '0')}:'
        '${orderModel.createdAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Banner ──────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.85),
                      primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
                child: Column(
                  children: [
                    // Animated check icon
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 36,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: const Text(
                        'Pembayaran Berhasil!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Text(
                        'Terima kasih telah menyelesaikan\npembayaran Anda.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.78),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Status Badge ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Color(0xFF3B6D11)),
                    SizedBox(width: 5),
                    Text(
                      'Lunas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B6D11),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Info Cards ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      _InfoCard(
                        icon: Icons.receipt_long_outlined,
                        label: 'Nomor Pesanan',
                        value: orderModel.orderNumber,
                        valueColor: primaryColor,
                      ),
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.access_time_outlined,
                        label: 'Waktu Pembayaran',
                        value: '$formattedDate   $formattedTime',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Divider ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey.shade200, height: 1),
              ),

              const SizedBox(height: 24),

              // ── Buttons ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Primary button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<MainViewmodel>().navigateToPages(3);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainScreen()), (route)=>false);
                        },
                        icon: const Icon(Icons.history_rounded, size: 20),
                        label: const Text('Lihat Riwayat Pesanan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Outline button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<MainViewmodel>().navigateToPages(0);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => MainScreen()),
                              (route) => false
                          );
                        },
                        icon: const Icon(Icons.home_outlined, size: 20),
                        label: const Text('Kembali ke Beranda'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 1.5),
                          foregroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable info card widget ─────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF185FA5)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                  letterSpacing: valueColor != null ? 0.4 : 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}