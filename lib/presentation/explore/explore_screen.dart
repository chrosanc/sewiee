import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/explore/explore_viewmodel.dart';
import 'package:sewiee/presentation/widget/category_widget.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ExploreViewmodel>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExploreViewmodel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(enabled: false, title: "Cari Produk"),
              SizedBox(height: 20),
              Text(
                'Telusuri Berdasarkan Kategori',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = vm.categories[index];
                  return CategoryWidget(name: item.name, iconUrl: item.iconUrl);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
