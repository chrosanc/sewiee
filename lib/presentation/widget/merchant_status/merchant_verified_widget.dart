import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';

class MerchantVerifiedWidget extends StatelessWidget {
  final Function() onTap;
  final String? storeName;
  final String? totalProduct;
  final String? activeOrder;
  final String? storeRating;

  const MerchantVerifiedWidget({super.key, required this.onTap, this.storeName, this.totalProduct, this.activeOrder, this.storeRating});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toko kamu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          storeName ?? 'Nama Toko',
                          maxLines: 2,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Kelola Toko >',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: onTap,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: themeData.primaryColor
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                //       child: Text('Pending', style: TextStyle(color: Colors.white, fontSize: 10),),
                //     ),
                //   ),
                // )
              ],
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: [
                merchantDetail(Zondicons.box, 'Total Produk', totalProduct ?? '0'),
                merchantDetail(Zondicons.shopping_cart, 'Order Aktif', activeOrder ?? '0'),
                merchantDetail(Zondicons.star_full, 'Rating Toko', storeRating ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card merchantDetail(String icon, String title, String amount) {
    return Card(
      color: themeData.primaryColor,
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(icon, color: Colors.white),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(amount, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
