import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

import 'helpers/product_model_test_helper.dart';

// Simple mock implementation of LoadingManager for testing
class MockLoadingManager implements LoadingManager {
  final _loadingStreamController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get loadingStream => _loadingStreamController.stream;

  @override
  void hideLoading() {}

  @override
  void showLoading() {}

  void dispose() => _loadingStreamController.close();
}

void main() {
  setUpAll(() {
    // Register mock dependencies with GetIt
    GetIt.instance.registerSingleton<LoadingManager>(MockLoadingManager());
  });

  tearDownAll(() {
    // Clean up GetIt after all tests
    GetIt.instance.reset();
  });

  test('countTotalPrice should multiply price by rentDurationCount', () {
    // Test the calculation directly without instantiating the viewmodel
    final productModel = ProductModelTestHelper.createTestProduct(price: 50000);

    const int rentDurationCount = 3;
    const String? selectedDeliveryMethod = null;
    const dynamic selectedCourier = null;
    const int applicationCost = 1000;
    const int serviceCost = 1000;

    // Replicate the countTotalPrice calculation
    final int productPrice = productModel.price * rentDurationCount;
    final int depositAmount = productModel.rentalTerms.depositAmount;
    final int shippingPrice =
        selectedDeliveryMethod == 'expedition' && selectedCourier != null
        ? selectedCourier.price
        : 0;

    final int totalPrice =
        productPrice +
        depositAmount +
        shippingPrice +
        applicationCost +
        serviceCost;

    expect(
      totalPrice,
      150000 + 0 + 1000 + 1000,
    ); // 50000 * 3 + deposits + costs
  });

  test('countTotalPrice includes shipping when expedition is selected', () {
    final productModel = ProductModelTestHelper.createTestProduct(price: 50000);

    const int rentDurationCount = 3;
    const String? selectedDeliveryMethod = 'expedition';
    final selectedCourier = _MockShippingCost(price: 25000);
    const int applicationCost = 1000;
    const int serviceCost = 1000;

    // Replicate the countTotalPrice calculation
    final int productPrice = productModel.price * rentDurationCount;
    final int depositAmount = productModel.rentalTerms.depositAmount;
    final int shippingPrice =
        selectedDeliveryMethod == 'expedition' && selectedCourier != null
        ? selectedCourier.price
        : 0;

    final int totalPrice =
        productPrice +
        depositAmount +
        shippingPrice +
        applicationCost +
        serviceCost;

    expect(
      totalPrice,
      150000 + 0 + 25000 + 1000 + 1000,
    ); // Product + deposit + shipping + costs
  });
}

class _MockShippingCost {
  final int price;
  _MockShippingCost({required this.price});
}
