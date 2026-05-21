import 'package:flutter/material.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/merchant/register/register_merchant_screen.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class SplashMerchantScreen extends StatefulWidget {
  const SplashMerchantScreen({super.key});

  @override
  State<SplashMerchantScreen> createState() => _SplashMerchantState();
}

class _SplashMerchantState extends State<SplashMerchantScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              children: [
                buildPage(
                  Icons.store,
                  'Mulai Bisnis Sewa Kamu',
                  'Hasilkan uang dari barangmu',
                ),
                buildPage(
                  Icons.inventory,
                  'Kelola Produk',
                  'Upload & Atur Produk kamu dengan Mudah',
                ),
                buildPage(
                  Icons.payments,
                  'Dapatkan Penghasilan',
                  'Terima order & tarik saldo',
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.all(4),
                width: currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? themeData.primaryColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: PrimaryButton(
              label: currentPage == 2 ? "Mulai" : "Berikutnya",
              isEnabled: true,
              isLoading: false,
              onPressed: () {
                if (currentPage == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterMerchantScreen()));
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: themeData.primaryColor),
          SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
