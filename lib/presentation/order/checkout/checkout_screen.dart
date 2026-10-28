import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/expedition_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/presentation/account/address/address_screen.dart';
import 'package:sewiee/presentation/order/checkout/checkout_viewmodel.dart';
import 'package:sewiee/presentation/order/checkout/expedition/select_expedition_screen.dart';
import 'package:sewiee/presentation/order/checkout/payment/method/payment_method_screen.dart';
import 'package:sewiee/presentation/order/checkout/payment/payment_screen.dart';
import 'package:sewiee/presentation/widget/bottomsheet/bottom_sheet_widget.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';

import 'payment/payment_webview_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await context.read<CheckoutViewmodel>().getCurrentUser();
      await context.read<CheckoutViewmodel>().getUserAddress();
      await context.read<CheckoutViewmodel>().getExpeditionById();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CheckoutViewmodel>(context);
    durationController.text = vm.rentDurationCount.toString();

    if (vm.isLoading == true) {
      return LoadingWidget();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Checkout', style: TextStyle(fontSize: 14))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                // =========================
                // ADDRESS DETAIL
                // =========================
                child: GestureDetector(
                  onTap: () async {
                    final AddressModel? address = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddressScreen()),
                    );

                    if (address != null) {
                      vm.setSelectedAddress(address);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat pengiriman & pengembalian kamu',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),

                            Row(
                              children: [
                                Iconify(
                                  Zondicons.location,
                                  color: themeData.primaryColor,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  vm.addressModel?.label ?? 'Label',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '|',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  vm.addressModel?.contactName ??
                                      'Nama Lengkap',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 5),
                            Text(
                              vm.addressModel?.fullAddress ?? 'Alamat Lengkap',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(thickness: 5, color: Colors.grey.shade200),
              // =========================
              // PRODUCT DETAIL
              // =========================
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Produk yang disewa', style: TextStyle(fontSize: 12)),
                    // Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.network(
                                vm.productModel?.images.first ??
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Question_Mark.svg/500px-Question_Mark.svg.png',
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              Gap(10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.productModel?.productName ??
                                          'Nama Produk',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${CurrencyUtils().toRupiah(vm.productModel?.price ?? 1000000)} / ${vm.productModel?.durationType ?? 'Bulan'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: themeData.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    vm.countRentDuration(false);
                                  },
                                  child: Text(
                                    '-',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Gap(15),
                                Container(
                                  width: 20,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: durationController,
                                    onChanged: (value) {
                                      vm.setRentDuration(value);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Gap(5),
                                Text(
                                  vm.productModel?.durationType ?? 'Hari',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Gap(15),
                                GestureDetector(
                                  onTap: () {
                                    vm.countRentDuration(true);
                                  },
                                  child: Text(
                                    '+',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(thickness: 5, color: Colors.grey.shade200),

              // =========================
              // DELIVERY AND RETURN
              // =========================
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // METODE PENGIRIMAN
                    TextInputWidget(
                      onTap: () {
                        AppBottomSheet.show(
                          context: context,
                          title: 'Metode Pengiriman',
                          child: Column(
                            children: [
                              StatefulBuilder(
                                builder: (bottomSheetContext, setModalState) {
                                  return Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,

                                        child: RadioGroup<String>(
                                          groupValue: vm.selectedDeliveryMethod,

                                          onChanged: (value) async {
                                            vm.setSelectedDeliveryMethod(
                                              value!,
                                            );

                                            setModalState(() {});
                                          },

                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),

                                            itemCount: vm
                                                .availableDeliveryOptions
                                                .length,

                                            itemBuilder: (context, index) {
                                              final item = vm
                                                  .availableDeliveryOptions[index];

                                              if (item['enabled'] == false) {
                                                return const SizedBox.shrink();
                                              }

                                              return RadioListTile<String>(
                                                value: item['value'].toString(),

                                                title: Text(
                                                  item['title'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      vm.selectedDeliveryMethod == 'expedition'
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  vm
                                                          .selectedCourier
                                                          ?.courierName ??
                                                      'Pilih Ekspedisi',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                trailing: Icon(
                                                  Icons
                                                      .keyboard_arrow_right_rounded,
                                                ),
                                                onTap: () async {
                                                  debugPrint(
                                                    vm.selectedDeliveryMethod,
                                                  );
                                                  if (vm.selectedDeliveryMethod ==
                                                      'expedition') {
                                                    final ShippingCostModel?
                                                    result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectExpeditionScreen(),
                                                      ),
                                                    );

                                                    if (result != null) {
                                                      setModalState(() {});
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      isButton: true,
                      title: 'Metode Pengiriman',
                      maxLines: 3,
                      hintText: vm.deliveryMethodText,
                    ),
                    Gap(10),
                    TextInputWidget(
                      isButton: true,
                      title: 'Metode Pengembalian',
                      hintText: vm.returnMethodText,
                      onTap: () {
                        AppBottomSheet.show(
                          context: context,
                          title: 'Metode Pengembalian',
                          child: Column(
                            children: [
                              StatefulBuilder(
                                builder: (bottomSheetContext, setModalState) {
                                  return Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,

                                        child: RadioGroup<String>(
                                          groupValue: vm.selectedReturnMethod,

                                          onChanged: (value) async {
                                            vm.setSelectedReturnMethod(value!);

                                            setModalState(() {});
                                          },

                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),

                                            itemCount: vm
                                                .availableReturnOptions
                                                .length,

                                            itemBuilder: (context, index) {
                                              final item = vm
                                                  .availableReturnOptions[index];

                                              if (item['enabled'] == false) {
                                                return const SizedBox.shrink();
                                              }

                                              return RadioListTile<String>(
                                                value: item['value'].toString(),

                                                title: Text(
                                                  item['title'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              Divider(thickness: 5, color: Colors.grey.shade200),
              // =========================
              // PAYMENT
              // =========================
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      isButton: true,
                      title: 'Metode Pembayaran',
                      hintText:
                          vm.selectedPaymentMethod?.name ??
                          'Pilih metode pembayaran',
                      onTap: () async {
                        final PaymentMethodModel? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentMethodScreen(),
                          ),
                        );

                        if (result != null) {
                          vm.setSelectedPaymentMethod(result);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 5, color: Colors.grey.shade200),

              // =========================
              // PRICE DETAIL
              // =========================
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Pembayaran'),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Harga (${vm.rentDurationCount} Bulan)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(
                            vm.productModel!.price * vm.rentDurationCount,
                          ),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deposit Jaminan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(
                            vm.productModel?.rentalTerms.depositAmount ?? 0,
                          ),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Ongkos Kirim',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          vm.selectedDeliveryMethod == 'expedition'
                              ? CurrencyUtils().toRupiah(
                                  vm.selectedCourier?.price ?? 0,
                                )
                              : 'Rp 0',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Layanan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(1000),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Jasa Aplikasi',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(1000),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Gap(10),
                    Divider(color: Colors.grey.shade300),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Harga', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyUtils().toRupiah(vm.countTotalPrice()),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: PrimaryButton(
          label: 'Bayar Sekarang',
          isEnabled: vm.checkFilledForm(),
          isLoading: vm.isLoading,
          onPressed: () async {
            final isFilled = vm.checkFilledForm();
            if (isFilled) {
              final result = await vm.createOrder();
              if (result != null) {
                final transaction = await vm.createMidtransTransaction();
                if (transaction != null && context.mounted) {
                  if (transaction.data!.paymentType == 'gopay') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentWebviewScreen(
                          url: transaction.data!.qrString!,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          paymentData: vm.midtransTransactionResponseModel!,
                        ),
                      ),
                    );
                  }
                }
              }
              // Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
            } else {
              Toast().showToast(
                context,
                'Isi detail pembayaran terlebih dahulu',
              );
            }
          },
        ),
      ),
    );
  }
}
