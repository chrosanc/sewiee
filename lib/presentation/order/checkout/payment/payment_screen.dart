import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/countdown_util.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/domain/repositories/order_repository.dart';
import 'package:sewiee/presentation/order/payment_success/payment_success_screen.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class PaymentScreen extends StatefulWidget {
  final MidtransTransactionResponseModel paymentData;
  final String orderId;

  const PaymentScreen({
    super.key,
    required this.paymentData,
    required this.orderId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isNavigating = false;
  late final Stream<OrderModel> _orderStream = OrderRepository().streamOrder(
    widget.orderId,
  );

  @override
  Widget build(BuildContext context) {
    final data = widget.paymentData.data;
    final paymentType = data?.paymentType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<OrderModel?>(
            stream: _orderStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final orderModel = snapshot.data;

              if (orderModel == null) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    Gap(16),
                    Text('Memuat pesanan...'),
                  ],
                );
              }

              // =========================
              // CHECK PAYMENT STATUS
              // =========================
              final isPaymentSuccess =
                  orderModel.payment.paymentStatus == 'paid' ||
                  orderModel.payment.paymentStatus == 'settlement';

              // =========================
              // AUTO NAVIGATE
              // =========================
              if (isPaymentSuccess && !_isNavigating) {
                _isNavigating = true;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentSuccessScreen(orderModel: orderModel),
                    ),
                  );
                });

                return const SizedBox.shrink();
              }

              // =========================
              // PAYMENT CONTENT
              // =========================
              return SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // =========================
                          // HEADER
                          // =========================
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.lock_clock,
                                      color: Colors.orange,
                                    ),
                                    const Gap(10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Bayar Sebelum',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat.formatDateTimeWIB(
                                            orderModel.payment.expiredAt ??
                                                DateTime.now(),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                StreamBuilder<String>(
                                  stream: countdownStream(
                                    orderModel.payment.expiredAt ??
                                        DateTime.now(),
                                  ),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data ?? '00 : 00 : 00',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          Divider(color: Colors.grey.shade300),

                          // =========================
                          // BANK TRANSFER
                          // =========================
                          if (paymentType == 'bank_transfer') ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Nomor Virtual Account',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            data
                                                    ?.vaNumbers
                                                    .firstOrNull
                                                    ?.vaNumber ??
                                                '0000000000',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const Gap(10),

                                          GestureDetector(
                                            onTap: () {
                                              final text =
                                                  data
                                                      ?.vaNumbers
                                                      .firstOrNull
                                                      ?.vaNumber ??
                                                  '';

                                              Clipboard.setData(
                                                ClipboardData(text: text),
                                              );

                                              Toast().showToast(
                                                context,
                                                'Nomor Virtual Account disalin',
                                              );
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              color: themeData.primaryColor,
                                              size: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  if (orderModel
                                      .payment
                                      .paymentMethod
                                      .image
                                      .isNotEmpty)
                                    Image.network(
                                      orderModel.payment.paymentMethod.image,
                                      width: 50,
                                    ),
                                ],
                              ),
                            ),
                          ]
                          // =========================
                          // QRIS
                          // =========================
                          else if (paymentType == 'qris') ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Kode QRIS Kamu'),
                                      const Gap(10),
                                      GestureDetector(
                                        onTap: () {
                                          final qrString = data?.qrString ?? '';

                                          Clipboard.setData(
                                            ClipboardData(text: qrString),
                                          );

                                          Toast().showToast(
                                            context,
                                            'QRIS disalin',
                                          );
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: themeData.primaryColor,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Gap(10),

                                  Center(
                                    child: Image.network(
                                      data?.qrString ?? '',
                                      width: 200,
                                      height: 200,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Text(
                                              'Gagal memuat QRIS',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // =========================
                          // TOTAL
                          // =========================
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Bayar',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      CurrencyUtils().toRupiah(
                                        orderModel.payment.amount.totalPayment,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: themeData.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const Text(
                                  'Detail Pembayaran >',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // =========================
                          // BUTTON
                          // =========================
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    isActive: true,
                                    onPressed: _checkPaymentStatus,
                                    label: 'Cek Status Bayar',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _checkPaymentStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengecek status pembayaran...')),
    );
  }
}
