import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/countdown_util.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/date_format.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class PaymentWidget extends StatelessWidget {
  final Function()? onTap;
  final String paymentId;
  final String productImage;
  final DateTime paymentDate;
  final DateTime paymentExpiredAt;
  final String paymentMethodImage;
  final String paymentMethod;
  final Function() onPayment;
  final Function() onCancel;
  final int totalPayment;
  const PaymentWidget({super.key, required this.paymentId, required this.paymentDate, required this.paymentExpiredAt, required this.paymentMethodImage, required this.paymentMethod, required this.onPayment, required this.onCancel, required this.totalPayment, required this.productImage, this.onTap, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(productImage, width: 40,),
                        Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(paymentId, style: TextStyle(fontSize:12),),
                            Text(DateFormat.formatDateTimeWIB(paymentDate), style: TextStyle(fontSize:12, color: Colors.grey),),
                          ],
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StreamBuilder<String>(
                          stream: countdownStream(
                           paymentExpiredAt,
                          ),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? '00 : 00 : 00',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Text(CurrencyUtils().toRupiah(totalPayment) ?? 'Rp 200,000', style: TextStyle(color: themeData.primaryColor, fontSize: 12),),
                      ],
                    )
                  ],
                ),
                Gap(10),

                Divider(color: Colors.grey.shade300,),
                Gap(10),

                Text('Metode Pembayaran' , style: TextStyle(fontSize: 12),),
                Gap(10),
                Row(
                  children: [
                    Image.network(paymentMethodImage, width: 50,),
                    Gap(10),
                    Text(paymentMethod.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Gap(20),

                Row(
                  children: [
                    Expanded(child: SecondaryButton(isActive: true, onPressed: onPayment, label: 'Lanjut Bayar')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: SecondaryButton(isActive: true, onPressed: onCancel, label: 'Batalkan Transaksi')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
