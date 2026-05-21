import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/category_model.dart';
import 'package:sewiee/presentation/account/address/address_screen.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';
import 'package:sewiee/presentation/add/add_product_viewmodel.dart';
import 'package:sewiee/presentation/widget/add_photos_widget.dart';
import 'package:sewiee/presentation/widget/bottomsheet/bottom_sheet_widget.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/checkbox_list_widget.dart';
import 'package:sewiee/presentation/widget/chip_widget.dart';
import 'package:sewiee/presentation/widget/dropdown_widget.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/multiline_text_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final proudctDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final locationController = TextEditingController();
  final productStockController = TextEditingController();
  final rentRuleController = TextEditingController();
  final fineController = TextEditingController();
  final depositController = TextEditingController();
  final expeditionWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AddProductViewmodel>(
        context,
        listen: false,
      ).loadExpeditions(context);
      Provider.of<AddProductViewmodel>(context, listen: false).loadCategories();
      Provider.of<AddProductViewmodel>(
        context,
        listen: false,
      ).getCurrentUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddProductViewmodel>(context);

    if (vm.isLoading) {
      return LoadingWidget();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text('Tambah Produk', style: TextStyle(fontSize: 14)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.storefront, size: 25),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vm.userModel?.storeName ?? 'Nama Toko',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        vm.userModel?.storeUsername ??
                                            'Username Toko',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Kelola Produk >',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// =========================
                /// PRODUCT PHOTO FORM CARD
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('Foto Produk', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 10),
                        AddPhotosWidget(
                          onTap: () {
                            vm.pickProductPhotos();
                          },
                        ),

                        vm.productPhotos.isNotEmpty
                            ? SizedBox(height: 10)
                            : SizedBox(),
                        if (vm.productPhotos.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.productPhotos.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: FileImage(
                                            vm.productPhotos[index],
                                          ),
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
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// =========================
                /// PRODUCT FORM CARD
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          title: 'Nama Produk',
                          controller: productNameController,
                        ),
                        SizedBox(height: 20),
                        MultilineTextWidget(
                          title: 'Deskripsi',
                          opsional: false,
                          controller: proudctDescriptionController,
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
                                selectedValue: vm.selectedDuration,
                                onChanged: (value) {
                                  vm.setSelectedDuration(value);
                                },
                                items: vm.rentDurations,
                                itemLabel: (item) => item,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextInputWidget(
                          title: 'Stok',
                          controller: productStockController,
                          keyboardType: TextInputType.number,
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
                      ],
                    ),
                  ),
                ),

                /// =========================
                /// LOCATION FORM CARD
                /// =========================
                SizedBox(height: 10),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        TextInputWidget(
                          isButton: true,
                          title: 'Lokasi Toko',
                          hintText: 'Pilih lokasi Toko kamu',
                          controller: locationController,
                          maxLines: 5,
                          onTap: () async {
                            context.read<AddressViewmodel>().setCurrentUser(
                              vm.userModel,
                            );
                            final AddressModel? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddressScreen(),
                              ),
                            );
                            if (result != null) {
                              vm.setSelectedAddress(result);
                              setState(() {
                                locationController.text =
                                    result.fullAddress ?? '';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// =========================
                /// DELIVERY AND RETURN FORM OPTIONS
                /// =========================
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              title: 'Pilih Metode Pengiriman',
                              description:
                              'Pilih metode yang dapat digunakan oleh penyewa',
                              child: StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CheckboxListWidget(
                                        title: 'Ambil Sendiri',
                                        value: vm.selectedDeliveryMethods
                                            .contains('pickup'),
                                        onChanged: (value) {
                                          vm.toggleDeliveryMethod('pickup');
                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                      Divider(color: Colors.grey.shade300),
                                      CheckboxListWidget(
                                        title: 'Diantar Penjual',
                                        value: vm.selectedDeliveryMethods
                                            .contains('seller_delivery'),
                                        onChanged: (value) {
                                          vm.toggleDeliveryMethod(
                                            'seller_delivery',
                                          );

                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                      Divider(color: Colors.grey.shade300),
                                      CheckboxListWidget(
                                        title: 'Ekspedisi',
                                        value: vm.selectedDeliveryMethods
                                            .contains('expedition'),
                                        onChanged: (value) {
                                          vm.toggleDeliveryMethod('expedition');
                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                      vm.selectedDeliveryMethods.contains(
                                        'expedition',
                                      )
                                          ? Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextInputWidget(
                                                controller: expeditionWeightController,
                                                hintText: 'Berat barang',
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text('kg'),
                                          ],
                                        ),
                                      )
                                          : SizedBox(),
                                      SizedBox(height: 20),
                                      vm.selectedDeliveryMethods.contains(
                                        'expedition',
                                      )
                                          ? Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pilih Kurir Ekspedisi',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: vm.expeditions.map((
                                                  expedition,) {
                                                return ChipWidget(
                                                  label: expedition
                                                      .courierName,

                                                  onSelected: (value) {
                                                    vm.toggleExpedition(
                                                      expedition.id,
                                                    );

                                                    setModalState(() {});
                                                  },

                                                  isSelected: vm
                                                      .selectedExpeditions
                                                      .contains(
                                                    expedition.id,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          isButton: true,
                          hintText: vm.deliveryMethodLabel,
                          title: 'Metode Pengiriman',
                        ),

                        SizedBox(height: 20),
                        TextInputWidget(
                          isButton: true,
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              title: 'Pilih Metode Pengembalian',
                              description:
                              'Pilih metode yang dapat digunakan oleh penyewa',
                              child: StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CheckboxListWidget(
                                        title: 'Diantar Sendiri',
                                        value: vm.selectedReturnMethods
                                            .contains('self_return'),
                                        onChanged: (value) {
                                          vm.toggleReturnMethod('self_return');
                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                      Divider(color: Colors.grey.shade300),
                                      CheckboxListWidget(
                                        title: 'Diantar Penjual',
                                        value: vm.selectedReturnMethods
                                            .contains('seller_pickup'),
                                        onChanged: (value) {
                                          vm.toggleReturnMethod(
                                              'seller_pickup');

                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                      Divider(color: Colors.grey.shade300),
                                      CheckboxListWidget(
                                        title: 'Ekspedisi',
                                        value: vm.selectedReturnMethods
                                            .contains('expedition_return'),
                                        onChanged: (value) {
                                          vm.toggleReturnMethod(
                                              'expedition_return');
                                          setModalState(() {});
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          hintText: vm.returnMethodLabel,
                          title: 'Metode Pengembalian',
                        ),
                      ],
                    ),
                  ),
                ),

                /// =========================
                /// RENT RULE FORM OPTIONS
                /// =========================
                SizedBox(height: 10),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aturan Sewa', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 5),
                        CheckboxListWidget(
                          value: vm.requireIdentity,
                          onChanged: (value) {
                            vm.setRequireIdentity(value!);
                          },
                          title: 'Wajib menunjukkan identitas (KTP/SIM)',
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        Divider(color: Colors.grey.shade300),

                        CheckboxListWidget(
                          value: vm.requireDeposit,
                          onChanged: (value) {
                            vm.setRequireDeposit(value!);
                          },
                          title: 'Wajib Deposit',
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        if (vm.requireDeposit)
                          TextInputWidget(
                            controller: depositController,
                            hintText: 'Tuliskan harga deposit',
                            keyboardType: TextInputType.number,
                          ),
                        vm.requireDeposit ? SizedBox(height: 10) : SizedBox(),
                        Divider(color: Colors.grey.shade300),

                        // CheckboxListWidget(
                        //   value: vm.cancellationAllowed,
                        //   onChanged: (value) {
                        //     vm.setCancellationAllowed(value!);
                        //   },
                        //   title: 'Denda Keterlambatan',
                        //   controlAffinity: ListTileControlAffinity.leading,
                        //   contentPadding: EdgeInsets.zero,
                        // ),

                        // if (vm.cancellationAllowed)
                        //   TextInputWidget(
                        //     controller: fineController,
                        //     hintText: 'Harga Denda',
                        //     keyboardType: TextInputType.number,
                        //   ),
                        // vm.cancellationAllowed
                        //     ? SizedBox(height: 10)
                        //     : SizedBox(),
                        // SizedBox(height: 10),
                        MultilineTextWidget(
                          title: 'Aturan Sewa Tambahan',
                          hintText: '',
                          opsional: true,
                          controller: rentRuleController,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  label: 'Tambah Produk',
                  isEnabled: true,
                  isLoading: vm.isLoading,
                  onPressed: () async {
                    final result = await vm.createProduct(context: context,
                        productNameController: productNameController,
                        descriptionController: proudctDescriptionController,
                        priceController: productPriceController,
                        stockController: productStockController,
                        depositController: depositController,
                        additionalNotesController: rentRuleController,
                        expeditionWeightController: expeditionWeightController,
                    );
                    if(result != null){
                      Toast().showToast(context, result!);
                    }
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
