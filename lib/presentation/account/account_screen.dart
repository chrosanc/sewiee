import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_screen.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/widget/loading_widget.dart';
import 'package:sewiee/presentation/widget/merchant_status/merchant_verified_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AccountViewmodel>(
        context,
        listen: false,
      ).getCurrentUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountViewmodel>(context);

    if (viewModel.isLoading || viewModel.userModel == null) {
      return LoadingWidget();
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return viewModel.getCurrentUser(context);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          viewModel.userModel?.profileImage == null
                              ? SizedBox()
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.userModel?.username ?? '@username',
                                style: TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                viewModel.userModel?.fullName ?? 'Nama Lengkap',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      MerchantVerifiedWidget(
                        storeName: viewModel.userModel?.storeName,
                        activeOrder: viewModel.userModel?.totalTransactions.toString(),
                        totalProduct: viewModel.userModel?.totalProducts.toString(),
                        storeRating: viewModel.userModel?.storeRating.toString(),

                        onTap: () {
                          context.read<ManageMerchantViewmodel>().setUser(viewModel.userModel!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageMerchantScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      menuWidget(
                        'Ubah Profil',
                        'Atur Identitas dan foto profil kamu',
                        Icons.person,
                        () {},
                      ),
                      SizedBox(height: 20),
                      menuWidget(
                        'Daftar Alamat',
                        'Atur Alamat Pengiriman',
                        Icons.pin_drop,
                        () {},
                      ),
                      SizedBox(height: 20),
                      menuWidget(
                        'Notifikasi',
                        'Atur Notifikasi Aplikasi',
                        Icons.notifications,
                        () {},
                      ),
                      SizedBox(height: 20),
                      menuWidget('Keluar', 'Keluar akun', Icons.logout, () {
                        viewModel.logout(context);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector menuWidget(
    String title,
    String description,
    IconData icon,
    Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
