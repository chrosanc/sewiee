import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_regular.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/app/utils/currency_utils.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/presentation/home/home_viewmodel.dart';
import 'package:sewiee/presentation/order/checkout/checkout_screen_non_mvvm.dart';
import 'package:sewiee/presentation/products/product_viewmodel.dart';
import 'package:sewiee/presentation/widget/bottomsheet/bottom_sheet_widget.dart';
import 'package:sewiee/presentation/widget/button_widget.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/product/product_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isExpanded = false;
  GoogleMapController? mapController;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().getAllProducts(context);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewmodel>(context);

    final vmHome = Provider.of<HomeViewModel>(context);
    final product = vm.product;
    if (product == null) {
      return LoadingWidget();
    }
    final randomProducts =
        vmHome.products
            .where((e) => e.id != product.id && e.active == true)
            .toList()
          ..shuffle();

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        actions: const [Icon(Icons.search)],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: PrimaryButton(
            label: 'Checkout',
            isEnabled: true,
            isLoading: false,
            onPressed: () {
              if (vm.product != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreenNonMvvm(),
                    settings: RouteSettings(arguments: vm.product!),
                  ),
                );
              } else {
                Toast().showToast(context, 'Produk tidak tersedia');
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SLIDER
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      final image = product.images[index];

                      return Image.network(image, fit: BoxFit.cover);
                    },
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: product.images.length,

                        effect: ExpandingDotsEffect(
                          dotHeight: 7,
                          dotWidth: 7,
                          dotColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// PRODUCT INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        CurrencyUtils().toRupiah(vm.product!.price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: themeData.primaryColor,
                        ),
                      ),

                      Text(
                        ' / ${product.durationType}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Wrap category in constrained box to prevent overflow
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: Text(
                      product.categoryName,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Wrap store name to prevent overflow
                      Expanded(
                        child: Text(
                          product.storeName,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Wrap location text with proper constraints
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          '${product.address.regency!.replaceAll('Kabupaten', '')}, ${product.address.province}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(10),

                  // MAPS
                  GestureDetector(
                    onTap: () {
                      vm.openGoogleMaps(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 100,
                        child: Stack(
                          children: [
                            GoogleMap(
                              scrollGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              rotateGesturesEnabled: false,
                              webCameraControlEnabled: false,
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  vm.product!.address.latitude!,
                                  vm.product!.address.longitude!,
                                ),
                                zoom: 10,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.location_pin,
                                color: themeData.primaryColor,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(thickness: 10, color: Colors.blueGrey.shade50),

            /// RENT RULES
            if (vm.product!.rentalTerms.requireDeposit ||
                vm.product!.rentalTerms.requireIdentity ||
                vm.product!.rentalTerms.additionalNotes.isNotEmpty)
              _sectionText(
                title: 'Aturan Sewa',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap ListTile with constrained width for identity
                    SizedBox(
                      width: double.maxFinite,
                      child: ListTile(
                        title: Text(
                          'Wajib menggunakan Identitas',
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Icon(Icons.perm_contact_calendar_outlined),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    // Wrap ListTile with constrained width for deposit
                    SizedBox(
                      width: double.maxFinite,
                      child: ListTile(
                        title: Text(
                          'Wajib deposit ${CurrencyUtils().toRupiah(vm.product!.rentalTerms.depositAmount)}',
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Iconify(Fa6Regular.money_bill_1),
                      ),
                    ),
                    Gap(10),
                    // Wrap additional notes in constrained box
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      child: Text(
                        vm.product!.rentalTerms.additionalNotes,
                        style: TextStyle(fontSize: 12),
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(),

            Divider(thickness: 10, color: Colors.blueGrey.shade50),

            /// DESCRIPTION
            _descriptionSectionText(
              title: 'Detail Produk',
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  child: Text(
                    product.description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              description: product.description,
            ),

            Divider(thickness: 10, color: Colors.blueGrey.shade50),

            /// OTHER PRODUCTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produk Lainnya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,

                      itemCount: randomProducts.length.clamp(0, 5),

                      separatorBuilder: (_, __) => const SizedBox(width: 10),

                      itemBuilder: (context, index) {
                        final anotherProduct = randomProducts[index];

                        return SizedBox(
                          width: 160,

                          child: ProductCard(
                            productName: anotherProduct.productName,

                            productPrice: anotherProduct.price,

                            durationType: anotherProduct.durationType,

                            category: anotherProduct.categoryName,

                            storeName: anotherProduct.storeName,

                            storeLocation: anotherProduct.address.district,

                            imageUrl: anotherProduct.images.first,

                            onTap: () {
                              context
                                  .read<ProductViewmodel>()
                                  .getDetailedProduct(
                                    context,
                                    anotherProduct.id,
                                  );
                              Navigator.pushReplacement(
                                context,

                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionSectionText({
    required String title,
    required Widget content,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Gap(10),

          // Wrap content in constrained box to prevent overflow
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              AppBottomSheet.show(
                context: context,

                title: title,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    description ?? 'Tidak ada Deskripsi',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            },

            child: Text(
              'Baca Selengkapnya',

              style: TextStyle(
                color: themeData.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionText({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Gap(10),

          content,

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              AppBottomSheet.show(
                context: context,

                title: title,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: content,
                ),
              );
            },

            child: Text(
              'Baca Selengkapnya',

              style: TextStyle(
                color: themeData.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
