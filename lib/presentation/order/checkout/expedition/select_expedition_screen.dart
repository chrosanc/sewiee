import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/presentation/order/checkout/checkout_viewmodel.dart';

class SelectExpeditionScreen extends StatefulWidget {
  const SelectExpeditionScreen({super.key});

  @override
  State<SelectExpeditionScreen> createState() => _SelectExpeditionScreenState();
}

class _SelectExpeditionScreenState extends State<SelectExpeditionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await context.read<CheckoutViewmodel>().getVillageCode();
      await context.read<CheckoutViewmodel>().getShippingCost();
      context.read<CheckoutViewmodel>().getExpeditionById();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CheckoutViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Ekspedisi', style: TextStyle(fontSize: 12)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = vm.filteredCouriers[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item?.courierName}',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(vm.countEstimationDate(item!.estimation) ?? 'Tidak ada Estimasi',
                              style: TextStyle(fontSize: 10, color: Colors.grey
                              ),
                              )
                            ],
                          ),
                          trailing: Text(

                            CurrencyUtils().toRupiah(item.price),
                            style: TextStyle(fontSize: 12),
                          ),
                          onTap: (){
                            vm.setSelectedExpedition(item);
                            Navigator.pop(context, vm.selectedCourier);
                          },
                        ),
                        item != vm.filteredCouriers.last
                            ? Divider(color: Colors.grey.shade300)
                            : SizedBox(),
                      ],
                    );
                  },
                  itemCount: vm.filteredCouriers.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
