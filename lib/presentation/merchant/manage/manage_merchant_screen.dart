import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_solid.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_product/manage_product_screen.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/merchant/horizontal_product_card.dart';
import 'package:sewiee/presentation/widget/merchant/merchant_order_card.dart';

class ManageMerchantScreen extends StatefulWidget {
  const ManageMerchantScreen({super.key});

  @override
  State<ManageMerchantScreen> createState() => _ManageMerchantScreenState();
}

class _ManageMerchantScreenState extends State<ManageMerchantScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ManageMerchantViewmodel>(
        context,
        listen: false,
      ).getProductByCurrentUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ManageMerchantViewmodel>(context);
    if(vm.isLoading) {
      return LoadingWidget();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kelola Toko',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                // KEUNTUNGAN
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Fa6Solid.money_bill, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Keuntungan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'Informasi lainnya >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Keuntungan',
                              style: TextStyle(fontSize: 12),
                            ),

                            Text(
                              'Rp 100.000',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(color: Colors.grey.shade300),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Produk',
                              style: TextStyle(fontSize: 12),
                            ),

                            Text(
                              '10 Produk',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(color: Colors.grey.shade300),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Order', style: TextStyle(fontSize: 12)),

                            Text(
                              '2 Order',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                    ],
                  ),
                ),

                //INFORMASI TOKO
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Fa6Solid.circle_info, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Informasi Toko',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'Ubah informasi >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nama toko', style: TextStyle(fontSize: 12)),

                            Text(
                              vm.userModel?.storeName ?? 'Nama Toko',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(color: Colors.grey.shade300),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Username toko',
                              style: TextStyle(fontSize: 12),
                            ),

                            Text(
                              vm.userModel?.storeUsername ?? '@username_toko',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                    ],
                  ),
                ),

                //PRODUK
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Fa6Solid.box_archive, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Produk Kamu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onTap: () async {
                                final ProductModel? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageProductScreen(),
                                  ),
                                );

                                if(result is ProductModel) {
                                  vm.getProductByCurrentUser(context);
                                }
                              },
                              child: Text(
                                'Kelola produk >',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: vm.listProduct.length.clamp(0, 5),
                        itemBuilder: (context, index) {
                          final item = vm.listProduct[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: HorizontalProductCard(
                                  photoUrl: item.images.first,
                                  name: item.productName,
                                  category: item.categoryName,
                                  price: item.price.toString(),
                                  durationType: item.durationType,
                                  active: item.active,
                                  stock: item.stock.toString(),
                                ),
                              ),
                              index == vm.listProduct.length - 1
                                  ? SizedBox(height: 10)
                                  : Divider(color: Colors.grey.shade300),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //ORDER
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Fa6Solid.clipboard_list, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Pesanan Toko',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'Lihat semua >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MerchantOrderCard(),
                      ),

                      SizedBox(height: 5),
                      Divider(color: Colors.grey.shade300),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MerchantOrderCard(),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
