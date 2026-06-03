import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/order/checkout/checkout_viewmodel.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await context.read<CheckoutViewmodel>().getPaymentMethods();

    });
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CheckoutViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [
          ListView.builder(itemBuilder: (context, index) {
            final item = vm.paymentMethods[index];

            return ListTile(
              title: Text(item?.name ?? '', style: TextStyle(fontSize: 12),),
              leading: Image.network(item!.image, width: 50, fit: BoxFit.fill,),
              onTap: (){
                vm.setSelectedPaymentMethod(item);
                Navigator.pop(context, item);
              },
            );
          },
            shrinkWrap: true,
            itemCount: vm.paymentMethods.length,
            physics: NeverScrollableScrollPhysics(),
          )
        ])),
      ),
    );
  }
}
