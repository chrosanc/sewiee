import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/app/utils/helpers/order_utils.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/manage_order_detail_bars.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/manage_order_detail_body.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_inspection_sheet.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_receipt_sheet.dart';

class ManageOrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const ManageOrderDetailScreen({super.key, required this.order});

  @override
  State<ManageOrderDetailScreen> createState() =>
      _ManageOrderDetailScreenState();
}

class _ManageOrderDetailScreenState extends State<ManageOrderDetailScreen> {
  late OrderModel _order;
  bool _isSubmitting = false;

  final TextEditingController receiptNumberController = TextEditingController();
  final TextEditingController brokenFineAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  OrderStatus get _status => _order.status;

  DeliveryMethod get _deliveryMethod {
    return DeliveryMethodX.fromString(_order.shipping.deliveryMethod);
  }

  Future<void> _performOrderAction(
    Future<OrderModel> Function(OrderViewmodel vm) action, {
    String? successMessage,
  }) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final nextOrder = await action(context.read<OrderViewmodel>());
      if (!mounted) return;

      setState(() => _order = nextOrder);
      _showSnack(
        successMessage ?? OrderUtils.statusUpdateMessage(nextOrder.status),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal memperbarui status: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _changeStatus(OrderStatus next) {
    return _performOrderAction(
      (vm) => vm.changeOrderStatus(order: _order, status: next),
    );
  }

  Future<void> _onProcessed() async {
    String? receiptNumber;

    if (_deliveryMethod == DeliveryMethod.expedition) {
      receiptNumber = await showReceiptNumberSheet(
        context,
        order: _order,
        controller: receiptNumberController,
      );
      if (receiptNumber == null || receiptNumber.isEmpty) return;
    }

    await _performOrderAction(
      (vm) => vm.markOrderProcessed(
        order: _order,
        deliveryMethod: _deliveryMethod,
        receiptNumber: receiptNumber,
      ),
    );
  }

  Future<void> _onInspection() async {
    final int? fineAmount = await showInspectionBrokenFineSheet(
      context,
      controller: brokenFineAmount,
      order: _order,
    );

    if (fineAmount == null) return;

    await _performOrderAction((vm) => vm.markOrderInspection(_order, fineAmount));
  }
  Future<void> _onStartRent() {
    return _performOrderAction((vm) => vm.markOrderOnRent(_order));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderDetailTheme.bg,
      appBar: ManageOrderDetailAppBar(
        order: _order,
        onBack: () => Navigator.pop(context),
      ),
      body: ManageOrderDetailBody(order: _order),
      bottomNavigationBar: ManageOrderBottomBar(
        status: _status,
        deliveryMethod: _deliveryMethod,
        isLoading: _isSubmitting,
        onReject: () => _changeStatus(OrderStatus.cancelled),
        onConfirm: () => _changeStatus(OrderStatus.processing),
        onProcessed: _onProcessed,
        onMarkPickedUp: _onStartRent,
        onItemOnRent: _onStartRent,
        onConfirmReturn: () => _changeStatus(OrderStatus.returned),
        onMarkReturned: () => _changeStatus(OrderStatus.returned),
        onInspection: () => _onInspection(),
        onComplete: () => _changeStatus(OrderStatus.completed),
      ),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFA32D2D) : null,
      ),
    );
  }
}
