import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/home/home_viewmodel.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/products/detail_product/product_detail_screen.dart';
import 'package:sewiee/presentation/products/product_viewmodel.dart';
import 'package:sewiee/presentation/widget/product/product_card.dart';
import 'package:sewiee/presentation/widget/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeViewModel>(context, listen: false).getUser(context);
      Provider.of<HomeViewModel>(
        context,
        listen: false,
      ).getAllProducts(context);
      Provider.of<HomeViewModel>(context, listen: false).getCategory();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.getUser(context);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              titleSpacing: 18,
              backgroundColor: Colors.white,
              pinned: true,
              floating: false,
              toolbarHeight: 70,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    context.read<MainViewmodel>().navigateToPages(1);
                  },
                  child: SearchWidget(enabled: false, title: "Cari Produk"),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _background(),
                    // _header(),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Telusuri Kategori', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                        GestureDetector(
                          onTap: (){
                            context.read<MainViewmodel>().navigateToPages(1);
                          },
                          child: Row(
                            children: [
                              Text('Lihat Semua', style: TextStyle(fontSize: 12, color: themeData.primaryColor),),
                              Gap(10),
                              Icon(Icons.arrow_forward_rounded, size: 15, color: themeData.primaryColor,)
                            ],
                          ),
                        )
                      ],
                    ),
                    Gap(10),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.categories.length.clamp(0, 6),
                        itemBuilder: (context, index) {
                          final item = viewModel.categories[index];
                          return _category(item.name, item.iconUrl);
                        },
                      ),
                    ),

                    _recommendationText(viewModel),
                    Gap(10),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.68, // card width / card height — tune if needed
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (viewModel.activeProducts.isEmpty) return const SizedBox.shrink();
                    final item = viewModel.activeProducts[index];
                    return ProductCard(
                      productName:   item.productName,
                      productPrice:  item.price,
                      storeName:     item.storeName,
                      category:      item.categoryName,
                      stock:         item.stock,
                      durationType:  item.durationType,
                      imageUrl:      item.images.first,
                      storeLocation: item.address.district,
                      onTap: () {
                        context.read<ProductViewmodel>().setProductModel(item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(),
                          ),
                        );
                      },
                    );
                  },
                  childCount: viewModel.activeProducts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _category(String categoryName, String categoryIcon) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: SvgPicture.network(categoryIcon, width: 20, height: 20),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            categoryName,
            style: const TextStyle(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(50),
            ),
            height: 48,
            width: 48,
            child: Icon(Icons.person, color: Colors.black38),
          ),
          SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo,'),

              // Text(viewModel.userProfile!.fullName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
            ],
          ),
        ],
      ),
    );
  }

  Column _recommendationText(HomeViewModel viewModel) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rekomendasi Barang",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _background() {
    return AspectRatio(
      aspectRatio: 16 / 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/sewiee_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column _headerTitle(HomeViewModel viewModel) {
    return Column(
      children: [
        Text(
          viewModel.userProfile!.fullName.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
