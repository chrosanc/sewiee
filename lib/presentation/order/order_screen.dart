import 'package:flutter/material.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';
import 'package:sewiee/presentation/widget/transaction_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 18,
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            toolbarHeight: 70,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 12),
              child: SearchWidget(
                enabled: true,
                  title: "Cari Transaksi"
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
