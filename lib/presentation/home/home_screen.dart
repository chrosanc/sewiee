import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/home/home_viewmodel.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/products/detail_product/product_detail_screen.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
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


    if (viewModel.isLoading) {
      return LoadingWidget();
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _background(),
                  const SizedBox(height: 12),
                  // _header(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.categories.length.clamp(0, 6),
                        itemBuilder: (context, index) {
                          final item = viewModel.categories[index];
                          return _category(item.name, item.iconUrl);
                        },
                      ),
                    ),
                  ),
                  _recommendationText(viewModel),
                ],
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 200,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = viewModel.activeProducts[index];
                  if(viewModel.activeProducts.isNotEmpty){
                    return ProductCard(
                      productName: item.productName,
                      productPrice: item.price,
                      storeName: item.storeName,
                      category: item.categoryName,
                      stock: item.stock,
                      durationType: item.durationType,
                      imageUrl: item.images.first,
                      storeLocation: item.address.district,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(productId: item.id,),
                          ),
                        );
                      },
                    );
                  } else {
                   return SizedBox();
                  }
                }, childCount: viewModel.activeProducts.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _category(
      String categoryName,
      String categoryIcon,
      ) {
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
              borderRadius:
              BorderRadius.circular(50),
            ),
            child: Center(
              child: SvgPicture.network(
                categoryIcon,
                width: 20,
                height: 20,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            categoryName,
            style: const TextStyle(
              fontSize: 10,
            ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rekomendasi Barang",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _background() {
    return AspectRatio(
      aspectRatio: 16 / 5,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
