import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_product/edit_product/edit_product_screen.dart';
import 'package:sewiee/presentation/widget/merchant/horizontal_product_card.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      Provider.of<ManageMerchantViewmodel>(context, listen: false).getUser(context);
      Provider.of<ManageMerchantViewmodel>(context, listen: false).getProductByCurrentUser(context);

    });
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ManageMerchantViewmodel>(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if(didPop) return;
        Navigator.pop(context, vm.productModel);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Kelola Produk', style: TextStyle(fontSize: 12)),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: SearchWidget(enabled: true, title: 'Cari Barangmu'),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: vm.listProduct.length,
                  itemBuilder: (context, index) {
                    final item = vm.listProduct[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () async {
                            vm.setProduct(context, item);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(),
                              ),
                            );

                            if(result == true) {
                              await vm.getProductByCurrentUser(context);
                            }
                          },
                          child: HorizontalProductCard(
                            photoUrl: item.images.first,
                            stock: item.stock.toString(),
                            active: item.active,
                            durationType: item.durationType,
                            price: item.price.toString(),
                            category: item.categoryName,
                            name: item.productName,
                          ),
                        ),
                        index == vm.listProduct.length - 1
                            ? const SizedBox(height: 10)
                            : Divider(color: Colors.grey.shade300),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
