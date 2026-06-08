import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/data/model/payment_model.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/domain/repositories/order_repository.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class OrderViewmodel extends ChangeNotifier {
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
  // ORDER VARIABLE
  // =========================
  List<OrderModel?> orders = [];
  List<OrderModel?> processedOrders = [];
  OrderModel? selectedOrderModel;
  final OrderRepository _orderRepository = OrderRepository();
  List<OrderModel?> unpaidOrders = [];
  OrderModel? selectedUnpaidOrder;
  OrderStatus? orderStatus;
  bool isWaitingPayment = false;

  // =========================
  // TRANSACTION VARIABLE
  // =========================
  TransactionModel? transactionModel;
  MidtransTransactionResponseModel? responseModel;

  // =========================
  // SETTERS
  // =========================

  void setSelectedOrderModel(OrderModel value) {
    selectedOrderModel = value;
    notifyListeners();
  }

  void setSelectedUnpaidOrder(OrderModel value) {
    selectedUnpaidOrder = value;
    notifyListeners();
  }

  void setSelectedIsWaitingPayment(bool value) {
    isWaitingPayment = value;
    notifyListeners();
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
  // ORDER FUNCTION
  // =========================

  Future<void> updateRenterOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {


    _showLoadingDialog();
    try {

      selectedOrderModel = await _orderRepository.updateOrderStatus(
        orderId: orderId,
        newStatus: status,
      );
      notifyListeners();

    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> updateDeliveredStatus() async {
    _showLoadingDialog();
    try {

      final startDate = DateTime.now();

      final endDate = OrderUtils.rentalEndDate(
        startDate: startDate,
        totalDuration: selectedOrderModel!.rental.totalDuration,
        durationType: selectedOrderModel!.productSnapshot.durationType,
      );

      final deliveredAt = DateTime.now();
      selectedOrderModel = await _orderRepository.updateDeliveredStatus(
        orderId: selectedOrderModel!.id,
        newStatus: OrderStatus.onRent,
        deliveredAt: deliveredAt,
        startDate: startDate,
        endDate: endDate,
      );
      notifyListeners();

    } finally {
      _hideLoadingDialog();
    }
  }

  // =========================
// RETURN FLOW
// =========================

  Future<OrderModel> confirmOrderReceived(OrderModel order) {
    return _runOrderMutation(() async {

      final startDate = DateTime.now();

      final endDate = OrderUtils.rentalEndDate(
        startDate: startDate,
        totalDuration: order.rental.totalDuration,
        durationType: order.productSnapshot.durationType,
      );

      final updatedOrder = await _orderRepository.updateDeliveredStatus(
        orderId: order.id,
        newStatus: OrderStatus.onRent,
        deliveredAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
      );

      selectedOrderModel = updatedOrder;
      notifyListeners();

      return updatedOrder;
    }, debugLabel: 'CONFIRM ORDER RECEIVED ERROR');
  }

  Future<OrderModel> submitReturnByExpedition({
    required OrderModel order,
    required String receiptNumber,
  }) {
    return _runOrderMutation(() async {

      await _orderRepository.submitReturnReceipt(
        orderId: order.id,
        receiptNumber: receiptNumber,
        courierCode: ,
        courierName: ,
      );

      final updatedOrder = order.copyWith(
        status: OrderStatus.returnOnDelivery,
        shipping: order.shipping.copyWith(
          returnTracking: (
              order.shipping.returnTracking ?? const ReturnTracking()
          ).copyWith(
            receiptNumber: receiptNumber,
            status: 'on_delivery',
            shippedAt: DateTime.now(),
          ),
        ),
      );

      selectedOrderModel = updatedOrder;
      notifyListeners();

      return updatedOrder;
    }, debugLabel: 'SUBMIT RETURN RECEIPT ERROR');
  }

  Future<OrderModel> confirmReturnReceived(OrderModel order) {
    return _runOrderMutation(() async {

      final updatedOrder = await _orderRepository.updateOrderStatus(
        orderId: order.id,
        newStatus: OrderStatus.returned,
      );

      selectedOrderModel = updatedOrder;
      notifyListeners();

      return updatedOrder;
    }, debugLabel: 'CONFIRM RETURN RECEIVED ERROR');
  }

// =========================
// PENALTY FLOW
// =========================

  Future<OrderModel> payDamagePenalty(OrderModel order) {
    return _runOrderMutation(() async {

      await _orderRepository.payPenalty(
        orderId: order.id,
      );

      final updatedOrder = await _orderRepository.updateOrderStatus(
        orderId: order.id,
        newStatus: OrderStatus.completed,
      );

      selectedOrderModel = updatedOrder;
      notifyListeners();

      return updatedOrder;
    }, debugLabel: 'PAY DAMAGE PENALTY ERROR');
  }

  Future<void> payPenalty({
    required String orderId,
  }) async {
    _showLoadingDialog();
    try {

      await _orderRepository.payPenalty(
        orderId: orderId,
      );

    } catch(e){
      debugPrint(e.toString());
    } finally {

      _hideLoadingDialog();
    }
  }

  Stream<List<OrderModel>> streamOrderByOwnerId() {
    return _orderRepository.streamOrderByOwnerId(userModel!.uid);
  }

  Future<T> _runOrderMutation<T>(
    Future<T> Function() action, {
    required String debugLabel,
  }) async {
    _showLoadingDialog();
    try {
      return await action();
    } catch (e) {
      debugPrint('$debugLabel: $e');
      rethrow;
    } finally {
      _hideLoadingDialog();
    }
  }

  // =========================
  // TRANSACTION FUNCTION
  // =========================

  Future<MidtransTransactionResponseModel?> createMidtransTransaction() async {
    try {
      if (selectedUnpaidOrder == null || userModel == null) {
        throw Exception('Data transaksi tidak lengkap');
      }

      // =========================
      // TRANSACTION MODEL
      // =========================

      transactionModel = TransactionModel(
        orderDocId: selectedUnpaidOrder!.id,

        orderNumber: selectedUnpaidOrder!.orderNumber,

        grossAmount: selectedUnpaidOrder!.payment.amount.totalPayment,

        paymentMethod: selectedUnpaidOrder!.payment.paymentMethod,

        customer: MidtransCustomer(
          name: selectedUnpaidOrder!.address.renter.contactName!,

          email: userModel!.email,

          phone: selectedUnpaidOrder!.address.renter.contactPhoneNumber!,
          shippingAddress: MidtransShippingAddress(
            firstName: selectedUnpaidOrder!.address.renter.contactName!,
            fullAddress: selectedUnpaidOrder!.address.renter.fullAddress!,
          ),
        ),

        itemDetails: [
          // =========================
          // PRODUCT
          // =========================
          MidtransItemDetail(
            id: selectedUnpaidOrder!.productSnapshot.id,

            price: selectedUnpaidOrder!.productSnapshot.price,

            quantity: selectedUnpaidOrder!.rental.totalDuration,

            name: selectedUnpaidOrder!.productSnapshot.name,
          ),
        ],
      );

      // =========================
      // CREATE TRANSACTION
      // =========================

      return responseModel = await _orderRepository.createTransaction(
        transactionModel!,
      );
    } catch (e) {
      debugPrint('CREATE MIDTRANS ERROR : $e');
      return null;
    } finally {}
  }

  Future<void> updateRentDate({
    required String orderId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return _runOrderMutation(
      () => _orderRepository.updateRentDate(
        orderId: orderId,
        startDate: startDate,
        endDate: endDate,
      ),
      debugLabel: 'UPDATE RENT DATE ERROR',
    );
  }
  // ===========================================================================
  // USER ORDER DETAIL FUNCTION
  // ===========================================================================
  //
  // Future<void> getOrdersByRenterId() async {
  //   _showLoadingDialog();
  //   try{
  //     orders = await _orderRepository.getOrderByRenterId(userModel!.uid);
  //     unpaidOrders = orders.where((e) => e!.status == OrderStatus.waitingPayment ).toList();
  //     processedOrders = orders.where((e) => e!.status != OrderStatus.waitingPayment).toList();
  //     notifyListeners();
  //   } catch(e) {
  //     debugPrint(e.toString());
  //   } finally{
  //     _hideLoadingDialog();
  //   }
  // }

  Stream<List<OrderModel>> streamOrderByRenterId() {
    return _orderRepository.streamOrderByRenterId(userModel!.uid);
  }

  Stream<OrderModel> streamOrder(){
    return _orderRepository.streamOrder(selectedOrderModel!.id);
  }

  // ===========================================================================
  // MERCHANT ORDER DETAIL FUNCTION
  // ===========================================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    return _runOrderMutation(
      () => _orderRepository.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
      ),
      debugLabel: 'UPDATE STATUS ERROR',
    );
  }

  Future<void> updateDeliveryReceiptNumber({
    required String orderId,
    required String receiptNumber,
  }) async {
    return _runOrderMutation(
      () => _orderRepository.updateDeliveryReceiptNumber(
        orderId: orderId,
        receiptNumber: receiptNumber,
      ),
      debugLabel: 'UPDATE RECEIPT ERROR',
    );
  }

  Future<OrderModel> changeOrderStatus({
    required OrderModel order,
    required OrderStatus status,
  }) {
    return _runOrderMutation(() async {
      await _orderRepository.updateOrderStatus(
        orderId: order.id,
        newStatus: status,
      );
      return order.copyWith(status: status);
    }, debugLabel: 'CHANGE ORDER STATUS ERROR');
  }

  Future<OrderModel> markOrderProcessed({
    required OrderModel order,
    required DeliveryMethod deliveryMethod,
    String? receiptNumber,
  }) {
    return _runOrderMutation(() async {
      if (deliveryMethod == DeliveryMethod.expedition) {
        final trimmedReceipt = receiptNumber?.trim();
        if (trimmedReceipt == null || trimmedReceipt.isEmpty) {
          throw Exception('Nomor resi tidak boleh kosong');
        }

        await _orderRepository.updateDeliveryReceiptNumber(
          orderId: order.id,
          receiptNumber: trimmedReceipt,
        );

        final tracking =
            (order.shipping.deliveryTracking ?? const DeliveryTracking())
                .copyWith(
                  receiptNumber: trimmedReceipt,
                  status: 'on_delivery',
                  shippedAt: DateTime.now(),
                );

        return order.copyWith(
          status: OrderStatus.onDelivery,
          shipping: order.shipping.copyWith(deliveryTracking: tracking),
        );
      }

      await _orderRepository.updateOrderStatus(
        orderId: order.id,
        newStatus: OrderStatus.waitingPickup,
      );

      return order.copyWith(status: OrderStatus.waitingPickup);
    }, debugLabel: 'MARK ORDER PROCESSED ERROR');
  }

  Future<OrderModel> markOrderInspection(
    OrderModel order,
    int? brokenFineAmount,
  ) {
    return _runOrderMutation(() async {
      OrderStatus status = (brokenFineAmount != null && brokenFineAmount > 0)
          ? OrderStatus.damageClaim
          : OrderStatus.completed;

      await _orderRepository.updateInspection(
        orderId: order.id,
        fine: brokenFineAmount ?? 0,
        status: status.value,
      );

      return order.copyWith(
        rental: order.rental.copyWith(brokenFine: brokenFineAmount ?? 0),
        status: status,
      );
    }, debugLabel: 'ONINSPECTION ERROR');
  }

  Future<OrderModel> markOrderOnRent(OrderModel order) {
    return _runOrderMutation(() async {
      final startDate = DateTime.now();
      final endDate = OrderUtils.rentalEndDate(
        startDate: startDate,
        totalDuration: order.rental.totalDuration,
        durationType: order.productSnapshot.durationType,
      );

      await _orderRepository.updateRentDate(
        orderId: order.id,
        startDate: startDate,
        endDate: endDate,
      );
      await _orderRepository.updateOrderStatus(
        orderId: order.id,
        newStatus: OrderStatus.onRent,
      );

      return order.copyWith(
        status: OrderStatus.onRent,
        rental: order.rental.copyWith(startDate: startDate, endDate: endDate),
      );
    }, debugLabel: 'MARK ORDER ON RENT ERROR');
  }
}
