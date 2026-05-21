import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/firebase_options.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';
import 'package:sewiee/presentation/add/add_product_screen.dart';
import 'package:sewiee/presentation/add/add_product_viewmodel.dart';
import 'package:sewiee/presentation/explore/explore_viewmodel.dart';
import 'package:sewiee/presentation/home/home_viewmodel.dart';
import 'package:sewiee/presentation/login/login_screen.dart';
import 'package:sewiee/presentation/login/login_viewmodel.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/merchant/register/register_merchant_viewmodel.dart';
import 'package:sewiee/presentation/products/product_viewmodel.dart';
import 'package:sewiee/presentation/register/register_viewmodel.dart';
import 'package:sewiee/presentation/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => AccountViewmodel()),
        ChangeNotifierProvider(create: (_) => MainViewmodel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterMerchantViewmodel()),
        ChangeNotifierProvider(create: (_) => AddProductViewmodel()),
        ChangeNotifierProvider(create: (_) => ExploreViewmodel()),
        ChangeNotifierProvider(create: (_) => ProductViewmodel()),
        ChangeNotifierProvider(create: (_) => ManageMerchantViewmodel()),
        ChangeNotifierProvider(create: (_) => AddressViewmodel()),
      ],
      child: MaterialApp(
        theme: themeData,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );

  }
}
