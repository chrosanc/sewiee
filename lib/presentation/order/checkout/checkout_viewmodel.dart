import 'package:flutter/material.dart';
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
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';
import 'package:uuid/uuid.dart';

class CheckoutViewmodel extends ChangeNotifier {
  // =========================
  // GENERAL VARIABLE
  // =========================

  bool isLoading = false;
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();

  void _showLoadingDialog() => _loadingManager.showLoading();

  void _hideLoadingDialog() => _loadingManager.hideLoading();


  // =========================
  // USER VARIABLE
  // =========================
  UserModel? userModel;
  final UserRepository _userRepository = UserRepository();

  // =========================
  // ADDRESS VARIABLE
  // =========================
  AddressModel? addressModel;
  List<AddressModel?> addresses = [];
  final AddressRepository _addressRepository = AddressRepository();

  // =========================
  // PRODUCT VARIABLE
  // =========================
  ProductModel? productModel;
  DeliveryOptionsModel? deliveryOptionsModel;
  ReturnOptions? returnOptionsModel;

  // =========================
  // CHECKOUT VARIABLE
  // =========================
  int rentDurationCount = 1;
  String? selectedDeliveryMethod;
  String? selectedReturnMethod;

  // =========================
  // PAYMENT VARIABLE
  // =========================
  List<PaymentMethodModel?> paymentMethods = [];
  PaymentMethodModel? selectedPaymentMethod;
  PaymentRepository paymentRepository = PaymentRepository();
  int totalPrice = 0;
  int serviceCost = 1000;
  int applicationCost = 1000;

  // =========================
  // ORDER VARIABLE
  // =========================
  OrderModel? orderModel;
  final OrderRepository _orderRepository = OrderRepository();
  TransactionModel? transactionModel;
  MidtransTransactionResponseModel? midtransTransactionResponseModel;

  // =========================
  // EXPEDITION VARIABLE
  // =========================
  ShippingCostModel? selectedCourier;
  String? destinationVillageCode;
  String? originVillageCode;
  List<ShippingCostModel?> shippingCostModel = [];
  List<ExpeditionModel> couriers = [];
  List<ShippingCostModel?> filteredCouriers = [];
  final ExpeditionRepository _expeditionRepository = ExpeditionRepository();

  // =========================
  // GETTERS
  // =========================
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

  // =========================
  // SETTERS
  // =========================
  void setSelectedAddress(AddressModel model) {
    addressModel = model;
    notifyListeners();
  }

  void setSelectedProduct(ProductModel model) {
    productModel = model;
    deliveryOptionsModel = productModel!.deliveryOptions;
    returnOptionsModel = productModel!.returnOptions;
    notifyListeners();
  }

  void setCountRentDuration(int count) {
    rentDurationCount = count;
    notifyListeners();
  }

  void setRentDuration(String value) {
    final int? parsed = int.tryParse(value);

    if (parsed == null || parsed < 1) {
      rentDurationCount = 1;
    } else {
      rentDurationCount = parsed;
    }
    notifyListeners();
  }

  void setSelectedDeliveryMethod(String value) {
    selectedDeliveryMethod = value;
    notifyListeners();
  }

  void setSelectedReturnMethod(String value) {
    selectedReturnMethod = value;
    notifyListeners();
  }

  void setSelectedExpedition(ShippingCostModel value) {
    selectedCourier = value;
    notifyListeners();
  }

  void setSelectedPaymentMethod(PaymentMethodModel value) {
    selectedPaymentMethod = value;
    notifyListeners();
  }

  // =========================
  // PAYMENT FUNCTION
  // =========================

  Stream<OrderModel> streamOrder(){
    return _orderRepository.streamOrder(orderModel!.id);
  }


  Future<void> getPaymentMethods() async {
    _showLoadingDialog();
    try {
      paymentMethods = await paymentRepository.getPaymentMethod();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  int countTotalPrice() {
    final int productPrice = (productModel?.price ?? 0) * rentDurationCount;

    final int depositAmount = productModel?.rentalTerms.depositAmount ?? 0;

    // Ongkir hanya masuk jika metode pengiriman adalah ekspedisi DAN sudah memilih ekspedisi
    final int shippingPrice = selectedDeliveryMethod == 'expedition' && selectedCourier != null
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

  // =========================
  // CHECKOUT FUNCTION
  // =========================
  void countRentDuration(bool iteration) {
    if (iteration) {
      rentDurationCount++;
      notifyListeners();
    } else {
      if (rentDurationCount != 1) {
        rentDurationCount--;
        notifyListeners();
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
    notifyListeners();

    try {
      // =========================
      // VALIDATION
      // =========================

      if (productModel == null ||
          userModel == null ||
          addressModel == null ||
          selectedPaymentMethod == null ||
          selectedDeliveryMethod == null ||
          selectedReturnMethod == null) {
        throw Exception('Data checkout belum lengkap');
      }

      // =========================
      // ORDER ID
      // =========================

      final String orderId = Uuid().v4();

      final String orderNumber = await _orderRepository.generateOrderNumber();

      // =========================
      // TOTAL PRICE
      // =========================

      final int totalUserPayment = countTotalPrice();


      // =========================
      // ORDER MODEL
      // =========================

      orderModel = OrderModel(
        // BASIC
        id: orderId,

        orderNumber: orderNumber,

        // USER
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

        // PRODUCT
        productSnapshot: ProductSnapshot(
          id: productModel!.id,
          name: productModel!.productName,
          image: productModel!.images.first,
          price: productModel!.price,
          durationType: productModel!.durationType,
        ),

        // ADDRESS
        address: Address(renter: addressModel!, store: productModel!.address),

        // RENTAL
        rental: RentalDetail(

          totalDuration: rentDurationCount,

          lateFee: 0,

          isLate: false,
        ),

        // SHIPPING
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

        // PAYMENT
        payment: PaymentDetail(
          paymentMethod: selectedPaymentMethod!,

          paymentStatus: 'pending',

          transactionId: '',

          amount: Amount(
            productPrice: productModel!.price * rentDurationCount,

            // Ongkir hanya masuk jika metode pengiriman adalah ekspedisi DAN sudah memilih ekspedisi
            deliveryFee: selectedDeliveryMethod == 'expedition' && selectedCourier != null
                ? selectedCourier!.price
                : 0,

            depositAmount: productModel!.rentalTerms.depositAmount,

            applicationFee: applicationCost,

            serviceFee: serviceCost,

            totalPayment: totalUserPayment,

          ),

          expiredAt: DateTime.now().add(Duration(days: 1)),
        ),

        // STATUS
        status: OrderStatus.waitingPayment,

        // DATE
        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );

      // =========================
      // SAVE TO FIRESTORE WITH STOCK TRANSACTION
      // =========================
      try {
        // Gunakan transaksi untuk mengurangi stok dan membuat order secara atomik
        await _orderRepository.createOrderWithStockCheck(
          orderId: orderId,
          productId: productModel!.id,
          orderData: orderModel!.toJson(),
        );

        debugPrint('Order berhasil dibuat dengan stok ter-reservasi');
        notifyListeners();
        return orderModel;
      } catch (e) {
        debugPrint('Error saat create order: $e');
        
        // Cek apakah error karena stok habis
        if (e.toString().toLowerCase().contains('stok produk habis')) {
          // Tampilkan pesan error ke user (asumsi ada cara untuk menampilkan snackbar/dialog)
          // serviceLocator<DialogManager>().showErrorSnackBar('Stok produk habis! Silahkan pilih produk lain.');
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
      notifyListeners();
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

      // =========================
      // TRANSACTION MODEL
      // =========================

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
          // =========================
          // PRODUCT
          // =========================
          MidtransItemDetail(
            id: productModel!.id,

            price: productModel!.price,

            quantity: rentDurationCount,

            name: productModel!.productName,
          ),

        ],
      );

      // =========================
      // CREATE TRANSACTION
      // =========================

      return midtransTransactionResponseModel = await _orderRepository.createTransaction(transactionModel!);

    } catch (e) {
      debugPrint('CREATE MIDTRANS ERROR : $e');
      return null;
    } finally {
    }
  }

  // =========================
  // USER FUNCTION
  // =========================
  Future<void> getCurrentUser() async {
    _showLoadingDialog();
    try {
      userModel = await _userRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  // =========================
  // ADDRESS FUNCTION
  // =========================
  Future<void> getUserAddress() async {
    _showLoadingDialog();
    try {
      addresses = await _addressRepository.getUserAddresses(userModel!.uid);
      addressModel = addresses.first;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  // =========================
  // EXPEDITIONS FUNCTION
  // =========================

  String? countEstimationDate(String? estimation) {
    if (estimation == null || estimation.isEmpty) {
      return 'Tidak ada estimasi';
    }
    _showLoadingDialog();
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
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> getExpeditionById() async {
    _showLoadingDialog();
    final courierIds = productModel!.deliveryOptions.expedition.couriers;
    try {
      couriers = await _expeditionRepository.getExpeditionsById(courierIds);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> getShippingCost() async {
    _showLoadingDialog();
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
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> getVillageCode() async {
    _showLoadingDialog();
    try {
      // Tujuan alamat
      final destinationPostalCode = addressModel!.postCode;
      final destinationVillageName = addressModel!.village;

      // alamat toko
      final originPostalCode = productModel!.address.postCode;
      final originVillageName = productModel!.address.village;

      //Ambil kode desa tujuan
      destinationVillageCode = await _expeditionRepository.getVillageCode(
        destinationPostalCode!,
        destinationVillageName!,
      );

      // Ambil kode desa toko
      originVillageCode = await _expeditionRepository.getVillageCode(
        originPostalCode!,
        originVillageName!,
      );

      // print('VILLAGE CODE : ${destinationVillageCode.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }
}
