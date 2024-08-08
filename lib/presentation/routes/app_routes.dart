import 'package:go_router/go_router.dart';

import '../../domain/entities/payment_model.dart';
import '../../domain/entities/product_model.dart';
import '../pages/auth/login_screen.dart';
import '../pages/auth/register_screen.dart';
import '../pages/cart/cart_screen.dart';
import '../pages/main_home.dart';
import '../pages/product/add_product_screen.dart';
import '../pages/product/product_detail_screen.dart';
import '../pages/product/product_screen.dart';
import '../pages/profile/profile_screen.dart';
import '../pages/splash_screen.dart';
import '../pages/transaction/checkout/checkout_screen.dart';
import '../pages/transaction/history_transaction/history_transaction_detail_screen.dart';
import '../pages/transaction/history_transaction/history_transaction_screen.dart';
import '../pages/transaction/payment/payment_screen.dart';

abstract class RoutesName {
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const home = 'home';
  static const products = 'products';
  static const addProducts = 'add-products';
  static const productsDetail = 'products-detail';
  static const cart = 'cart';
  static const profile = 'profile';
  static const checkout = 'checkout';
  static const payment = 'payment';
  static const historyTransaction = 'history-transaction';
  static const historyTransactionDetail = 'history-transaction-detail';
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RoutesName.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/${RoutesName.register}',
      name: RoutesName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/${RoutesName.login}',
      name: RoutesName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${RoutesName.home}',
      name: RoutesName.home,
      builder: (context, state) => const MainHome(),
    ),
    GoRoute(
        path: '/${RoutesName.products}',
        name: RoutesName.products,
        builder: (context, state) => const ProductScreen(),
        routes: <GoRoute>[
          GoRoute(
              path: RoutesName.productsDetail,
              name: RoutesName.productsDetail,
              builder: (context, state) {
                ProductModel arg = state.extra! as ProductModel;
                return ProductDetailScreen(product: arg);
              }),
        ]),
    GoRoute(
      path: '/${RoutesName.addProducts}',
      name: RoutesName.addProducts,
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/${RoutesName.profile}',
      name: RoutesName.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
        path: '/${RoutesName.cart}',
        name: RoutesName.cart,
        builder: (context, state) => const CartScreen(),
        routes: <GoRoute>[
          GoRoute(
              path: RoutesName.checkout,
              name: RoutesName.checkout,
              builder: (context, state) {
                List<ProductCheckout> arg =
                    state.extra! as List<ProductCheckout>;
                return CheckoutScreen(productCheckout: arg);
              },
              routes: <GoRoute>[
                GoRoute(
                  path: RoutesName.payment,
                  name: RoutesName.payment,
                  builder: (context, state) {
                    PaymentModel totalPayment = state.extra! as PaymentModel;
                    return PaymentScreen(paymentModel: totalPayment);
                  },
                ),
              ]),
        ]),
    GoRoute(
        path: '/${RoutesName.historyTransaction}',
        name: RoutesName.historyTransaction,
        builder: (context, state) {
          return const HistoryTransactionScreen();
        },
        routes: <GoRoute>[
          GoRoute(
            path: RoutesName.historyTransactionDetail,
            name: RoutesName.historyTransactionDetail,
            builder: (context, state) {
              PaymentModel paymentModel = state.extra! as PaymentModel;
              return HistoryTransactionDetailScreen(payment: paymentModel);
            },
          ),
        ]),
  ],
);
