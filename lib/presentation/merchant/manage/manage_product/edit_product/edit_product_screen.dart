import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/widget/add_photos_widget.dart';
import 'package:sewiee/presentation/widget/dropdown_widget.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/multiline_text_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final locationController = TextEditingController();
  final productStockController = TextEditingController();
  final rentRuleController = TextEditingController();
  final fineController = TextEditingController();
  final depositController = TextEditingController();
  bool isProductUpdated = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ManageMerchantViewmodel>(
        context,
        listen: false,
      ).initializeEditProduct(
        context,
        productNameController,
        productDescriptionController,
        productPriceController,
        locationController,
        productStockController,
        rentRuleController,
        fineController,
        depositController,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ManageMerchantViewmodel>(context);

    if (vm.isLoading) {
      return LoadingWidget();
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) return;
        Navigator.pop(context, vm.productModel);
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Hapus Produk?'),
                          content: Text(
                            'Apakah anda yakin untuk menghapus produk ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final result = await vm.deleteProduct(context);
                                if (result == true) {
                                  setState(() {
                                    isProductUpdated = true;
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                }


                              },
                              child: Text('Ya'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete_outline, size: 30, color: Colors.grey),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await vm.setProductActive(context);
                    if (result) {
                      setState(() {
                        isProductUpdated == true;
                        vm.syncProduct(vm.productModel!);
                      });
                    }
                  },
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: vm.productModel!.active
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    vm.productModel!.active
                        ? 'Nonaktifkan Produk'
                        : 'Aktifkan Produk',
                    style: TextStyle(
                      color: vm.productModel!.active ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
              Gap(20),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(themeData.primaryColor),
                    side: WidgetStatePropertyAll(BorderSide.none),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Konfirmasi Produk'),
                          content: Text('Apakah anda yakin data sudah benar?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final result = await vm.updateProduct(
                                  context,
                                  productNameController,
                                  productDescriptionController,
                                  productPriceController,
                                  productStockController,
                                  locationController,
                                  rentRuleController,
                                  depositController,
                                  fineController,
                                );
                
                                if(result == true) {
                                  setState(() {
                                    isProductUpdated = true;
                                  });
                                  Navigator.pop(dialogContext);
                                  await vm.refreshProduct(
                                    context,
                                  );
                                }
                
                              },
                              child: Text('Ya'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Konfirmasi Ubah',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gap(20),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          actions: [
            Text(
              vm.productModel?.active == true ? 'Aktif' : 'Tidak Aktif',
              style: TextStyle(
                fontSize: 12,
                color: vm.productModel?.active == true
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          title: Text(
            vm.productModel?.productName ?? 'Nama Produk',
            style: TextStyle(fontSize: 12),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('Ubah Produk'),
                  SizedBox(height: 20),
                  AddPhotosWidget(
                    onTap: () {
                      vm.pickProductPhoto();
                    },
                  ),
                  SizedBox(height: 10),
                  if (vm.productPhotos.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.productPhotos.length,
                        itemBuilder: (context, index) {
                          final photo = vm.productPhotos[index];
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: photo is File
                                        ? FileImage(photo)
                                        : NetworkImage(photo) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    vm.removePhoto(index);
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 10),
                  TextInputWidget(
                    title: 'Nama Produk',
                    controller: productNameController,
                  ),
                  SizedBox(height: 20),
                  MultilineTextWidget(
                    title: 'Deskripsi',
                    opsional: true,
                    controller: productDescriptionController,
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextInputWidget(
                          title: 'Harga',
                          controller: productPriceController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text('/'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DropdownWidget<String>(
                          selectedValue: vm.selectedDurationType,
                          onChanged: (value) {
                            setState(() {
                              vm.selectedDurationType = value;
                            });
                          },
                          items: vm.rentDurationType,
                          itemLabel: (item) => item,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  DropdownWidget<CategoryModel>(
                    title: 'Kategori Barang',
                    selectedValue: vm.selectedCategory,
                    onChanged: (value) {
                      vm.setSelectedCategory(value);
                    },
                    items: vm.categories,
                    itemLabel: (item) => item.name,
                  ),
                  SizedBox(height: 20),
                  TextInputWidget(
                    isButton: true,
                    title: 'Lokasi',
                    controller: locationController,
                  ),
                  SizedBox(height: 20),
                  TextInputWidget(
                    title: 'Stok',
                    controller: productStockController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  MultilineTextWidget(
                    title: 'Aturan Sewa',
                    opsional: true,
                    controller: rentRuleController,
                  ),
                  SizedBox(height: 5),
                  CheckboxListTile(
                    enabled: false,
                    value: vm.identityRequired,
                    onChanged: (value) {
                      vm.setSelectedidentity(value);
                    },
                    title: Text(
                      'Wajib menunjukkan identitas (KTP/SIM)',
                      style: TextStyle(fontSize: 12),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    enabled: false,
                    value: vm.depositRequired,
                    onChanged: (value) {
                      vm.setSelectedDeposit(value);
                    },
                    title: Text('Wajib Deposit', style: TextStyle(fontSize: 12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),

                  if (vm.depositRequired)
                    TextInputWidget(
                      controller: depositController,
                      title: 'Deposit',
                      keyboardType: TextInputType.number,
                    ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
