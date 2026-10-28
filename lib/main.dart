import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/firebase_options.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/account/address/address_viewmodel.dart';
import 'package:sewiee/presentation/add/add_product_viewmodel.dart';
import 'package:sewiee/presentation/explore/explore_viewmodel.dart';
import 'package:sewiee/presentation/home/home_viewmodel.dart';
import 'package:sewiee/presentation/login/login_viewmodel.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/merchant/register/register_merchant_viewmodel.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:sewiee/presentation/products/product_viewmodel.dart';
import 'package:sewiee/presentation/register/register_viewmodel.dart';
import 'package:sewiee/presentation/splash/splash_screen.dart';
import 'package:sewiee/presentation/widget/loading/dialog_manager.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';
import 'package:sewiee/data/services/notification_service.dart';

import 'presentation/order/checkout/checkout_viewmodel.dart';

Future<void> main() async {
  setupLocator();
  _initDialogManager();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  runApp(const MyApp());
}
final serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton<LoadingManager>(
        () => LoadingManager(),
  );
  serviceLocator.registerLazySingleton<DialogManager>(
        () => DialogManager(MyApp.navigatorKey, serviceLocator<LoadingManager>()),
  );
}

void _initDialogManager() => serviceLocator<DialogManager>().init();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProvider(create: (_) => CheckoutViewmodel()),
        ChangeNotifierProvider(create: (_) => OrderViewmodel()),
      ],
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        theme: themeData,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );

  }
}
