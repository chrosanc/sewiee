import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/presentation/merchant/manage/manage_order/manage_order_detail_screen.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/widget/merchant/merchant_order_card.dart';

class ManageOrderScreen extends StatefulWidget {
  const ManageOrderScreen({super.key});

  @override
  State<ManageOrderScreen> createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<OrderViewmodel>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewmodel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Pesanan Toko',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A18))),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE8E6E0)),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<OrderModel>>(
          stream: vm.streamOrderByOwnerId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  const Text('Belum ada pesanan',
                      style: TextStyle(fontSize: 13, color: Color(0xFF888780))),
                ]),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (context, index) {
                final item = orders[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFE8E6E0), width: 0.5),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      // Pass the full OrderModel — no extra fetch needed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ManageOrderDetailScreen(order: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: MerchantOrderCard(
                        image: item.productSnapshot.image,
                        totalPayment: CurrencyUtils()
                            .toRupiah(item.payment.amount.totalPayment),
                        productName: item.productSnapshot.name,
                        duration: item.rental.totalDuration.toString(),
                        durationType: item.productSnapshot.durationType,
                        status: item.status,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}