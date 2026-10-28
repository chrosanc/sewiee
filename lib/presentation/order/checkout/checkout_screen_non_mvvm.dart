import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/address_model.dart';
import 'package:sewiee/data/model/expedition_model.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/data/model/product_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/domain/repositories/address_repository.dart';
import 'package:sewiee/domain/repositories/expedition_repository.dart';
import 'package:sewiee/domain/repositories/order_repository.dart';
import 'package:sewiee/domain/repositories/payment_repository.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/presentation/account/address/address_screen.dart';
import 'package:sewiee/presentation/order/checkout/payment/payment_screen.dart';
import 'package:sewiee/presentation/widget/bottomsheet/bottom_sheet_widget.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/text_input_widget.dart';
import 'package:uuid/uuid.dart';

import 'payment/payment_webview_screen.dart';

class CheckoutScreenNonMvvm extends StatefulWidget {
  const CheckoutScreenNonMvvm({super.key});

  @override
  State<CheckoutScreenNonMvvm> createState() => _CheckoutScreenNonMvvmState();
}

class _CheckoutScreenNonMvvmState extends State<CheckoutScreenNonMvvm> {
  final TextEditingController durationController = TextEditingController();

  bool isLoading = false;

  UserModel? userModel;
  final UserRepository _userRepository = UserRepository();

  AddressModel? addressModel;
  List<AddressModel?> addresses = [];
  final AddressRepository _addressRepository = AddressRepository();

  ProductModel? productModel;
  DeliveryOptionsModel? deliveryOptionsModel;
  ReturnOptions? returnOptionsModel;

  int rentDurationCount = 1;
  String? selectedDeliveryMethod;
  String? selectedReturnMethod;

  List<PaymentMethodModel?> paymentMethods = [];
  PaymentMethodModel? selectedPaymentMethod;
  PaymentRepository paymentRepository = PaymentRepository();
  int totalPrice = 0;
  int serviceCost = 1000;
  int applicationCost = 1000;

  OrderModel? orderModel;
  final OrderRepository _orderRepository = OrderRepository();
  TransactionModel? transactionModel;
  MidtransTransactionResponseModel? midtransTransactionResponseModel;

  ShippingCostModel? selectedCourier;
  String? destinationVillageCode;
  String? originVillageCode;
  List<ShippingCostModel?> shippingCostModel = [];
  List<ExpeditionModel> couriers = [];
  List<ShippingCostModel?> filteredCouriers = [];
  final ExpeditionRepository _expeditionRepository = ExpeditionRepository();
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductModel) {
      setSelectedProduct(args);
    }

    Future.microtask(() async {
      await getCurrentUser();
      await getUserAddress();
      await getExpeditionById();
    });
  }

  @override
  void dispose() {
    durationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get availableDeliveryOptions {
    return [
      {
        "value": "pickup",
        "title": "Ambil Sendiri",
        "enabled": deliveryOptionsModel?.pickup.enabled ?? false,
      },
      {
        "value": "seller_delivery",
        "title": "Diantar Penjual",
        "enabled": deliveryOptionsModel?.sellerDelivery.enabled ?? false,
      },
      {
        "value": "expedition",
        "title": "Ekspedisi",
        "enabled": deliveryOptionsModel?.expedition.enabled ?? false,
      },
    ];
  }

  List<Map<String, dynamic>> get availableReturnOptions {
    return [
      {
        "value": "self_return",
        "title": "Antar Sendiri",
        "enabled": returnOptionsModel?.selfReturn.enabled ?? false,
      },
      {
        "value": "seller_pickup",
        "title": "Diambil Penjual",
        "enabled": returnOptionsModel?.sellerPickup.enabled ?? false,
      },
      {
        "value": "expedition_return",
        "title": "Ekspedisi",
        "enabled": returnOptionsModel?.expeditionReturn.enabled ?? false,
      },
    ];
  }

  String get deliveryMethodText {
    switch (selectedDeliveryMethod) {
      case 'pickup':
        return 'Ambil Sendiri';
      case 'seller_delivery':
        return 'Diantar Penjual';
      case 'expedition':
        if (selectedCourier == null) {
          return 'Pilih Ekspedisi';
        }
        return 'Ekspedisi\n'
            '${selectedCourier!.courierName}\n'
            '${countEstimationDate(selectedCourier!.estimation)}';
      default:
        return 'Pilih metode pengiriman';
    }
  }

  String get returnMethodText {
    switch (selectedReturnMethod) {
      case 'self_return':
        return 'Antar Sendiri';
      case 'seller_pickup':
        return 'Diambil Penjual';
      case 'expedition_return':
        return 'Ekspedisi';
      default:
        return 'Pilih metode pengiriman';
    }
  }

  bool get isVA {
    return midtransTransactionResponseModel!.data!.paymentType ==
        'bank_transfer';
  }

  bool get isQRIS {
    return midtransTransactionResponseModel!.data!.paymentType == 'qris';
  }

  bool get isEwallet {
    return midtransTransactionResponseModel!.data!.paymentType == 'gopay';
  }

  String get vaNumber {
    final vaNumbers = midtransTransactionResponseModel?.data?.vaNumbers;

    if (vaNumbers == null || vaNumbers.isEmpty) {
      return '-';
    }

    return vaNumbers.first.vaNumber;
  }

  String get bankName {
    final vaNumbers = midtransTransactionResponseModel?.data?.vaNumbers;

    if (vaNumbers == null || vaNumbers.isEmpty) {
      return '-';
    }

    return vaNumbers.first.bank.toUpperCase();
  }

  void setSelectedAddress(AddressModel model) {
    addressModel = model;
    if (mounted) setState(() {});
  }

  void setSelectedProduct(ProductModel model) {
    productModel = model;
    deliveryOptionsModel = productModel!.deliveryOptions;
    returnOptionsModel = productModel!.returnOptions;
    if (mounted) setState(() {});
  }

  void setCountRentDuration(int count) {
    rentDurationCount = count;
    if (mounted) setState(() {});
  }

  void setRentDuration(String value) {
    final int? parsed = int.tryParse(value);

    if (parsed == null || parsed < 1) {
      rentDurationCount = 1;
    } else {
      rentDurationCount = parsed;
    }
    if (mounted) setState(() {});
  }

  void setSelectedDeliveryMethod(String value) {
    selectedDeliveryMethod = value;
    if (value != 'expedition') {
      selectedCourier = null;
    }
    if (mounted) setState(() {});
  }

  void setSelectedReturnMethod(String value) {
    selectedReturnMethod = value;
    if (mounted) setState(() {});
  }

  void setSelectedExpedition(ShippingCostModel value) {
    selectedCourier = value;
    if (mounted) setState(() {});
  }

  void setSelectedPaymentMethod(PaymentMethodModel value) {
    selectedPaymentMethod = value;
    if (mounted) setState(() {});
  }

  Stream<OrderModel> streamOrder() {
    return _orderRepository.streamOrder(orderModel!.id);
  }

  Future<void> getPaymentMethods() async {
    try {
      paymentMethods = await paymentRepository.getPaymentMethod();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int countTotalPrice() {
    final int productPrice = (productModel?.price ?? 0) * rentDurationCount;
    final int depositAmount = productModel?.rentalTerms.depositAmount ?? 0;
    final int shippingPrice =
        selectedDeliveryMethod == 'expedition' && selectedCourier != null
            ? selectedCourier!.price
            : 0;

    totalPrice =
        productPrice +
        depositAmount +
        shippingPrice +
        applicationCost +
        serviceCost;

    return totalPrice;
  }

  void countRentDuration(bool iteration) {
    if (iteration) {
      rentDurationCount++;
      if (mounted) setState(() {});
    } else {
      if (rentDurationCount != 1) {
        rentDurationCount--;
        if (mounted) setState(() {});
      }
    }
  }

  bool checkFilledForm() {
    if (selectedDeliveryMethod == null ||
        selectedReturnMethod == null ||
        selectedPaymentMethod == null ||
        addressModel == null) {
      return false;
    }

    if (selectedDeliveryMethod == 'expedition' && selectedCourier == null) {
      return false;
    }

    return true;
  }

  Future<OrderModel?> createOrder() async {
    isLoading = true;
    if (mounted) setState(() {});

    try {
      if (productModel == null ||
          userModel == null ||
          addressModel == null ||
          selectedPaymentMethod == null ||
          selectedDeliveryMethod == null ||
          selectedReturnMethod == null) {
        throw Exception('Data checkout belum lengkap');
      }

      final String orderId = const Uuid().v4();
      final String orderNumber = await _orderRepository.generateOrderNumber();
      final int totalUserPayment = countTotalPrice();

      orderModel = OrderModel(
        id: orderId,
        orderNumber: orderNumber,
        renterId: userModel!.uid,
        ownerId: productModel!.ownerId,
        renterSnapshot: UserSnapshot(
          id: userModel!.uid,
          name: userModel!.fullName,
          username: userModel!.username,
        ),
        ownerSnapshot: UserSnapshot(
          id: productModel!.ownerId,
          name: productModel!.storeName,
          username: productModel!.storeUsername,
          storeName: productModel!.storeName,
          storeUsername: productModel!.storeUsername,
          phoneNumber: productModel!.phoneNumber,
        ),
        productSnapshot: ProductSnapshot(
          id: productModel!.id,
          name: productModel!.productName,
          image: productModel!.images.first,
          price: productModel!.price,
          durationType: productModel!.durationType,
        ),
        address: Address(renter: addressModel!, store: productModel!.address),
        rental: RentalDetail(
          totalDuration: rentDurationCount,
          lateFee: 0,
          isLate: false,
        ),
        shipping: ShippingDetail(
          deliveryMethod: selectedDeliveryMethod!,
          returnMethod: selectedReturnMethod!,
          deliveryTracking: selectedDeliveryMethod == 'expedition'
              ? DeliveryTracking(
                  courierCode: selectedCourier?.courierCode,
                  courierName: selectedCourier?.courierName,
                  status: 'waiting_pickup',
                  estimation: selectedCourier?.estimation,
                )
              : null,
        ),
        payment: PaymentDetail(
          paymentMethod: selectedPaymentMethod!,
          paymentStatus: 'pending',
          transactionId: '',
          amount: Amount(
            productPrice: productModel!.price * rentDurationCount,
            deliveryFee:
                selectedDeliveryMethod == 'expedition' &&
                    selectedCourier != null
                ? selectedCourier!.price
                : 0,
            depositAmount: productModel!.rentalTerms.depositAmount,
            applicationFee: applicationCost,
            serviceFee: serviceCost,
            totalPayment: totalUserPayment,
          ),
          expiredAt: DateTime.now().add(const Duration(days: 1)),
        ),
        status: OrderStatus.waitingPayment,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await _orderRepository.createOrderWithStockCheck(
          orderId: orderId,
          productId: productModel!.id,
          orderData: orderModel!.toJson(),
        );

        debugPrint('Order berhasil dibuat dengan stok ter-reservasi');
        if (mounted) setState(() {});
        return orderModel;
      } catch (e) {
        debugPrint('Error saat create order: $e');

        if (e.toString().toLowerCase().contains('stok produk habis')) {
          throw Exception('Stok produk habis! Silahkan pilih produk lain.');
        } else {
          throw Exception('Gagal membuat pesanan. Silakan coba lagi.');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      if (mounted) setState(() {});
    }
  }

  Future<MidtransTransactionResponseModel?> createMidtransTransaction() async {
    try {
      if (orderModel == null ||
          userModel == null ||
          productModel == null ||
          selectedPaymentMethod == null) {
        throw Exception('Data transaksi tidak lengkap');
      }

      transactionModel = TransactionModel(
        orderDocId: orderModel!.id,
        orderNumber: orderModel!.orderNumber,
        grossAmount: orderModel!.payment.amount.totalPayment,
        paymentMethod: selectedPaymentMethod!,
        customer: MidtransCustomer(
          name: addressModel!.contactName!,
          email: userModel!.email,
          phone: addressModel!.contactPhoneNumber!,
          shippingAddress: MidtransShippingAddress(
            firstName: addressModel!.contactName!,
            fullAddress: addressModel!.fullAddress!,
          ),
        ),
        itemDetails: [
          MidtransItemDetail(
            id: productModel!.id,
            price: productModel!.price,
            quantity: rentDurationCount,
            name: productModel!.productName,
          ),
        ],
      );

      return midtransTransactionResponseModel = await _orderRepository
          .createTransaction(transactionModel!);
    } catch (e) {
      debugPrint('CREATE MIDTRANS ERROR : $e');
      return null;
    }
  }

  Future<void> getCurrentUser() async {
    try {
      userModel = await _userRepository.getCurrentUser();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getUserAddress() async {
    try {
      addresses = await _addressRepository.getUserAddresses(userModel!.uid);
      addressModel = addresses.first;
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String? countEstimationDate(String? estimation) {
    if (estimation == null || estimation.isEmpty) {
      return 'Tidak ada estimasi';
    }
    try {
      final cleaned = estimation.replaceAll(RegExp(r'[^0-9\-]'), '');
      final split = cleaned.split('-');
      if (split.length < 2) {
        return null;
      }

      final int startDay = int.parse(split[0].trim());
      final int endDay = int.parse(split[1].trim());

      final DateTime now = DateTime.now();
      final DateTime startDate = now.add(Duration(days: startDay));
      final DateTime endDate = now.add(Duration(days: endDay));

      final List<String> months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      return '${startDate.day} ${months[startDate.month]} - ${endDate.day} ${months[startDate.month]}';
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> getExpeditionById() async {
    final courierIds = productModel!.deliveryOptions.expedition.couriers;
    try {
      couriers = await _expeditionRepository.getExpeditionsById(courierIds);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getShippingCost() async {
    try {
      shippingCostModel = await _expeditionRepository.getShippingCost(
        destinationVillageCode!,
        originVillageCode!,
        productModel!.deliveryOptions.expedition.weight,
      );
      filteredCouriers = shippingCostModel.where((shipping) {
        return productModel!.deliveryOptions.expedition.couriers.contains(
          shipping!.courierCode,
        );
      }).toList();
      debugPrint('SHIPPINGCOSTMODEL : $shippingCostModel');
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getVillageCode() async {
    try {
      final destinationPostalCode = addressModel!.postCode;
      final destinationVillageName = addressModel!.village;

      final originPostalCode = productModel!.address.postCode;
      final originVillageName = productModel!.address.village;

      destinationVillageCode = await _expeditionRepository.getVillageCode(
        destinationPostalCode!,
        destinationVillageName!,
      );

      originVillageCode = await _expeditionRepository.getVillageCode(
        originPostalCode!,
        originVillageName!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _showPaymentMethodSheet() async {
    await getPaymentMethods();
    if (!mounted) return;

    AppBottomSheet.show(
      context: context,
      title: 'Metode Pembayaran',
      child: Column(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              final item = paymentMethods[index];

              return ListTile(
                title: Text(
                  item?.name ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
                leading: Image.network(
                  item!.image,
                  width: 50,
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  setSelectedPaymentMethod(item);
                  Navigator.pop(context);
                },
              );
            },
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Future<void> _showExpeditionSheet(StateSetter parentSetModalState) async {
    await getVillageCode();
    await getShippingCost();
    if (!mounted) return;

    AppBottomSheet.show(
      context: context,
      title: 'Pilih Ekspedisi',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = filteredCouriers[index];
                return Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item?.courierName}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            countEstimationDate(item!.estimation) ??
                                'Tidak ada Estimasi',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        CurrencyUtils().toRupiah(item.price),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        setSelectedExpedition(item);
                        parentSetModalState(() {});
                        Navigator.pop(context);
                      },
                    ),
                    item != filteredCouriers.last
                        ? Divider(color: Colors.grey.shade300)
                        : const SizedBox(),
                  ],
                );
              },
              itemCount: filteredCouriers.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    durationController.text = rentDurationCount.toString();

    if (isLoading == true) {
      return const LoadingWidget();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout', style: TextStyle(fontSize: 14))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () async {
                    final AddressModel? address = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddressScreen()),
                    );

                    if (address != null) {
                      setSelectedAddress(address);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alamat pengiriman & pengembalian kamu',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Iconify(
                                  Zondicons.location,
                                  color: themeData.primaryColor,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  addressModel?.label ?? 'Label',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  addressModel?.contactName ?? 'Nama Lengkap',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              addressModel?.fullAddress ?? 'Alamat Lengkap',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.network(
                                productModel?.images.first ??
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Question_Mark.svg/500px-Question_Mark.svg.png',
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const Gap(10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productModel?.productName ?? 'Nama Produk',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${CurrencyUtils().toRupiah(productModel?.price ?? 1000000)} / ${productModel?.durationType ?? 'Bulan'}',
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
                                    countRentDuration(false);
                                  },
                                  child: const Text(
                                    '-',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                const Gap(15),
                                Container(
                                  width: 20,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: durationController,
                                    onChanged: (value) {
                                      setRentDuration(value);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  productModel?.durationType ?? 'Hari',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Gap(15),
                                GestureDetector(
                                  onTap: () {
                                    countRentDuration(true);
                                  },
                                  child: const Text(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                                          groupValue: selectedDeliveryMethod,
                                          onChanged: (value) async {
                                            setSelectedDeliveryMethod(value!);
                                            setModalState(() {});
                                          },
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: availableDeliveryOptions.length,
                                            itemBuilder: (context, index) {
                                              final item = availableDeliveryOptions[index];

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
                                      selectedDeliveryMethod == 'expedition'
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  selectedCourier?.courierName ??
                                                      'Pilih Ekspedisi',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.keyboard_arrow_right_rounded,
                                                ),
                                                onTap: () async {
                                                  debugPrint(selectedDeliveryMethod);
                                                  if (selectedDeliveryMethod == 'expedition') {
                                                    await _showExpeditionSheet(
                                                      setModalState,
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                          : const SizedBox(),
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
                      hintText: deliveryMethodText,
                    ),
                    const Gap(10),
                    TextInputWidget(
                      isButton: true,
                      title: 'Metode Pengembalian',
                      hintText: returnMethodText,
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
                                          groupValue: selectedReturnMethod,
                                          onChanged: (value) async {
                                            setSelectedReturnMethod(value!);
                                            setModalState(() {});
                                          },
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: availableReturnOptions.length,
                                            itemBuilder: (context, index) {
                                              final item = availableReturnOptions[index];

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
              Padding(
                padding: const EdgeInsets.symmetric(
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
                          selectedPaymentMethod?.name ??
                          'Pilih metode pembayaran',
                      onTap: () async {
                        await _showPaymentMethodSheet();
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 5, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rincian Pembayaran'),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Harga ($rentDurationCount Bulan)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(
                            productModel!.price * rentDurationCount,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deposit Jaminan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(
                            productModel?.rentalTerms.depositAmount ?? 0,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Ongkos Kirim',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          selectedDeliveryMethod == 'expedition'
                              ? CurrencyUtils().toRupiah(
                                  selectedCourier?.price ?? 0,
                                )
                              : 'Rp 0',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Biaya Layanan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(1000),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Biaya Jasa Aplikasi',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          CurrencyUtils().toRupiah(1000),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Divider(color: Colors.grey.shade300),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Harga', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyUtils().toRupiah(countTotalPrice()),
                          style: const TextStyle(fontSize: 12),
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
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          label: 'Bayar Sekarang',
          isEnabled: checkFilledForm(),
          isLoading: isLoading,
          onPressed: () async {
            final isFilled = checkFilledForm();
            if (isFilled) {
              final result = await createOrder();
              if (result != null) {
                final transaction = await createMidtransTransaction();
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
                          paymentData: midtransTransactionResponseModel!,
                        ),
                      ),
                    );
                  }
                }
              }
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
