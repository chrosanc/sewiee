import 'package:flutter/material.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SearchWidget(enabled: true, title: "Cari Produk"),
          ],
        ),
      )),
    );
  }
}
