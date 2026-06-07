import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/checkout/payment/pending/pending_payment_screen.dart';
import 'package:sewiee/presentation/order/order_detail/order_detail_screen.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';
import 'package:sewiee/presentation/widget/transaction_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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

    if (vm.userModel == null) {
      return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 18,
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            toolbarHeight: 70,
            elevation: 0,

            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SearchWidget(enabled: true, title: "Cari Transaksi"),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              child: StreamBuilder<List<OrderModel>>(
                stream: vm.streamOrderByRenterId(),

                builder: (context, snapshot) {
                  // =========================
                  // LOADING
                  // =========================

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // =========================
                  // EMPTY
                  // =========================

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Belum ada transaksi'),
                      ),
                    );
                  }

                  // =========================
                  // DATA
                  // =========================

                  final orders = snapshot.data ?? [];

                  final unpaidOrders = orders
                      .where((e) => e.status == OrderStatus.waitingPayment)
                      .toList();

                  final processedOrders = orders
                      .where((e) => e.status != OrderStatus.waitingPayment)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // =========================
                      // WAITING PAYMENT
                      // =========================
                      if (unpaidOrders.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => PendingPaymentScreen(),
                              ),
                            );
                          },

                          child: Card(
                            color: Colors.white,

                            child: Padding(
                              padding: const EdgeInsets.all(10),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.punch_clock_rounded,

                                        color: themeData.primaryColor,

                                        size: 20,
                                      ),

                                      const Gap(10),

                                      const Text(
                                        'Menunggu Pembayaran',

                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),

                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // =========================
                      // ORDER LIST
                      // =========================
                      ListView.builder(
                        padding: EdgeInsets.zero,

                        itemCount: processedOrders.length,

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemBuilder: (context, index) {
                          final item = processedOrders[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TransactionWidget(
                              productImage: item.productSnapshot.image,

                              productName: item.productSnapshot.name,

                              storeName: item.ownerSnapshot.name,

                              totalPay: CurrencyUtils().toRupiah(
                                item.payment.amount.totalPayment,
                              ),

                              duration:
                                  '${item.rental.totalDuration} ${item.productSnapshot.durationType}',

                              enabledButton: false,

                              onTap: () {
                                context.read<OrderViewmodel>().setSelectedOrderModel(item);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailScreen(),
                                  ),
                                );
                              },

                              status: item.status,

                              buttonOnTap: () {},
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
