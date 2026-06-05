import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/order/checkout/checkout_viewmodel.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool isLoading = false;
  String? orderNumber;
  DateTime? paymentTime;

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }

  Future<void> _fetchOrderData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Ambil order terakhir dari user menggunakan viewmodel yang sudah ada
      final vm = Provider.of<CheckoutViewmodel>(context, listen: false);

      if (vm.orderModel != null) {
        setState(() {
          orderNumber = vm.orderModel!.orderNumber;
          paymentTime = vm.orderModel!.createdAt;
        });
      }
    } catch (e) {
      debugPrint('Error fetching order data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Sukses
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: themeData.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: themeData.primaryColor,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Terima kasih telah menyelesaikan pembayaran Anda.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Order Number Card
              if (orderNumber != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.receipt_long, color: Colors.grey.shade600),
                          Text(
                            'Nomor Pesanan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        orderNumber!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeData.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Payment Time Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.access_time, color: Colors.grey.shade600),
                          Text(
                            'Waktu Pembayaran',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        paymentTime != null
                            ? '${paymentTime!.day}/${paymentTime!.month}/${paymentTime!.year} ${paymentTime!.hour.toString().padLeft(2, '0')}:${paymentTime!.minute.toString().padLeft(2, '0')}'
                            : '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/order-history',
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Lihat Riwayat Pesanan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Kembali ke Beranda'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: themeData.primaryColor),
                      foregroundColor: themeData.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
