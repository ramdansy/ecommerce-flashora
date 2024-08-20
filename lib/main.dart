import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/common/utils/fcm_helper.dart';
import 'core/common/utils/notification_helper.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'presentation/cubit/bottom_nav/bottom_nav_cubit.dart';
import 'presentation/cubit/cart/cart_cubit.dart';
import 'presentation/cubit/cashier/cashier_cubit.dart';
import 'presentation/cubit/product_cubit/crud_product/crud_product_cubit.dart';
import 'presentation/cubit/product_cubit/product/product_cubit.dart';
import 'presentation/cubit/product_cubit/product_detail/product_detail_cubit.dart';
import 'presentation/cubit/profile/profile_cubit.dart';
import 'presentation/cubit/splashscreen/splash_screen_cubit.dart';
import 'presentation/cubit/transaction/checkout/checkout_cubit.dart';
import 'presentation/cubit/transaction/history/history_transaction_cubit.dart';
import 'presentation/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationHelper().initLocalNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmHelper().init();

  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SplashScreenCubit>()),
        BlocProvider(create: (context) => getIt<BottomNavCubit>()),
        BlocProvider(create: (context) => getIt<ProductCubit>()),
        BlocProvider(create: (context) => getIt<CartCubit>()),
        BlocProvider(create: (context) => getIt<HistoryTransactionCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<ProductDetailCubit>()),
        BlocProvider(create: (context) => getIt<CrudProductCubit>()),
        BlocProvider(create: (context) => getIt<CheckoutCubit>()),
        BlocProvider(create: (context) => getIt<CashierCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Flashora',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
