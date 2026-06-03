
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/widget/payment_widget.dart';

class PendingPaymentScreen extends StatefulWidget {
  const PendingPaymentScreen({super.key});

  @override
  State<PendingPaymentScreen> createState() => _PendingPaymentScreenState();
}

class _PendingPaymentScreenState extends State<PendingPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Menunggu Pembayaran', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder<List<OrderModel>>(
              stream: vm.streamOrderByRenterId(),
              builder: (context, snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }

                if(!snapshot.hasData) {
                  return SizedBox();
                }

                final orders = snapshot.data;
                final unpaidOrders = orders?.where((e) => e.status == OrderStatus.waitingPayment).toList() ?? [];

                return ListView.builder(
                  itemBuilder: (context, index){
                    final item = unpaidOrders[index];
                    return PaymentWidget(
                      productImage: item.productSnapshot.image,
                      paymentDate: item.createdAt,
                      paymentId: item.orderNumber,
                      paymentExpiredAt: item.payment.expiredAt!,
                      onPayment: (){},
                      onCancel: (){},
                      paymentMethod: item.payment.paymentMethod.name,
                      paymentMethodImage: item.payment.paymentMethod.image,
                      totalPayment: item.payment.amount.totalPayment,
                      onTap: (){},

                    );

                  },
                  itemCount: unpaidOrders.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
