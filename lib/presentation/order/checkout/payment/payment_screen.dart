import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/countdown_util.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/presentation/order/checkout/checkout_viewmodel.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class PaymentScreen extends StatefulWidget {
  final MidtransTransactionResponseModel paymentData;
  const PaymentScreen({super.key, required this.paymentData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPaymentSuccess = false;
  String paymentStatusText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    // Cek status dari order model di viewmodel
    final vm = Provider.of<CheckoutViewmodel>(context, listen: false);
    
    if (vm.orderModel != null) {
      final paymentStatus = vm.orderModel!.payment.paymentStatus;
      
      setState(() {
        isPaymentSuccess = paymentStatus == 'paid' || 
                           paymentStatus == 'settlement';
        
        if (isPaymentSuccess) {
          paymentStatusText = 'Pembayaran Berhasil!';
          
          // Navigate ke halaman order success
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/order-success',
            (route) => false,
          );
        } else {
          paymentStatusText = 'Menunggu Pembayaran...';
        }
      });
    }

    // Jika masih pending, cek setiap 5 detik
    if (!isPaymentSuccess && mounted) {
      Future.delayed(Duration(seconds: 5), () {
        _checkPaymentStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CheckoutViewmodel>(context);

    final paymentType = widget.paymentData.data!.paymentType;

    return Scaffold(
      appBar: AppBar(title: Text('Pembayaran', style: TextStyle(fontSize: 12))),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Bayar sebelum
                              Row(
                                children: [
                                  Icon(Icons.lock_clock, color: Colors.yellow),
                                  Gap(10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bayar Sebelum',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.formatDateTimeWIB(
                                          vm.orderModel!.payment.expiredAt!,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  StreamBuilder<String>(
                                    stream: countdownStream(
                                      vm.orderModel!.payment.expiredAt!,
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? '00 : 00 : 00',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Divider(color: Colors.grey.shade300),

                        // =========================
                        // VIRTUAL ACCOUNT
                        // =========================
                        if (paymentType == 'bank_transfer') ...[
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nomor Virtual Account',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          vm
                                                  .midtransTransactionResponseModel
                                                  ?.data
                                                  ?.vaNumbers
                                                  .first
                                                  .vaNumber ??
                                              '0000000000',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Gap(10),
                                        GestureDetector(
                                          onTap: () {
                                            final text =
                                                vm
                                                    .midtransTransactionResponseModel
                                                    ?.data
                                                    ?.vaNumbers
                                                    .first
                                                    .vaNumber ??
                                                '';

                                            Clipboard.setData(
                                              ClipboardData(text: text),
                                            );
                                            if (text.isNotEmpty) {
                                              Toast().showToast(
                                                context,
                                                'Nomor Virtual Account disalin',
                                              );
                                            }
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

                                Image.network(
                                  vm.selectedPaymentMethod!.image,
                                  width: 50,
                                ),
                              ],
                            ),
                          ),

                          //QRIS
                        ] else if (paymentType == 'qris') ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Kode QRIS Kamu'),
                                    Gap(10),
                                    Icon(
                                      Icons.copy,
                                      color: themeData.primaryColor,
                                      size: 15,
                                    ),
                                  ],
                                ),

                                const Gap(10),

                                Center(
                                  child: Image.network(
                                    'https://www.drupal.org/files/styles/grid-3-2x/public/project-images/googleQRcodes.png?itok=CHGtlQMI',
                                    width: 200,
                                    height: 200,
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
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Bayar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    CurrencyUtils().toRupiah(
                                      vm.transactionModel!.grossAmount,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: themeData.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                'Detail Pembayaran >',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (paymentType == 'bank_transfer') ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    isActive: true,
                                    onPressed: () {},
                                    label: 'Cek Status Bayar',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (paymentType == 'qris') ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        isActive: true,
                                        onPressed: () {},
                                        label: 'Download QRIS',
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        isActive: true,
                                        onPressed: () {},
                                        label: 'Cek Status Bayar',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
