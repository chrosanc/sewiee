import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/account/account_screen.dart';
import 'package:sewiee/presentation/add/add_product_screen.dart';
import 'package:sewiee/presentation/explore/explore_screen.dart';
import 'package:sewiee/presentation/home/home_screen.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/order/order_screen.dart';
import 'package:sewiee/presentation/products/products_screen.dart';
import 'package:sewiee/presentation/widget/navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    AddProductScreen(),
    OrderScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewmodel>(context);
    return Scaffold(
      body: _screens[viewModel.currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: viewModel.currentIndex,
        onTap: (index) => viewModel.navigateToPages(index),
      ),
    );
  }
}
