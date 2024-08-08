import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/auth_datasource.dart';
import 'data/datasources/cart_datasource.dart';
import 'data/datasources/product_datasource.dart';
import 'data/datasources/transaction_datasource.dart';
import 'data/datasources/user_datasource.dart';
import 'data/repositories/auth_repositories_impl.dart';
import 'data/repositories/cart_repositories_impl.dart';
import 'data/repositories/product_repositories_impl.dart';
import 'data/repositories/transaction_repositories_impl.dart';
import 'data/repositories/user_repositories_impl.dart';
import 'domain/repositories/auth_repositories.dart';
import 'domain/repositories/cart_repositories.dart';
import 'domain/repositories/product_repositories.dart';
import 'domain/repositories/transaction_repositories.dart';
import 'domain/repositories/user_repositories.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/cart/add_cart_usecase.dart';
import 'domain/usecases/cart/delete_cart_usecase.dart';
import 'domain/usecases/cart/get_cart_by_user_id_usecase.dart';
import 'domain/usecases/cart/update_quantity_usecase.dart';
import 'domain/usecases/product/add_product_usecase.dart';
import 'domain/usecases/product/delete_product_usecase.dart';
import 'domain/usecases/product/get_all_products_usecase.dart';
import 'domain/usecases/product/get_product_by_id_usecase.dart';
import 'domain/usecases/product/update_price_usecase.dart';
import 'domain/usecases/product/update_product_usecase.dart';
import 'domain/usecases/product/update_stock_usecase.dart';
import 'domain/usecases/transaction/create_transaction_usecase.dart';
import 'domain/usecases/transaction/get_all_transaction_usecase.dart';
import 'domain/usecases/users/create_user_usecase.dart';
import 'domain/usecases/users/get_user_by_id_usecase.dart';
import 'presentation/cubit/auth/login/login_cubit.dart';
import 'presentation/cubit/auth/register/register_cubit.dart';
import 'presentation/cubit/bottom_nav/bottom_nav_cubit.dart';
import 'presentation/cubit/cart/cart_cubit.dart';
import 'presentation/cubit/product_cubit/crud_product/crud_product_cubit.dart';
import 'presentation/cubit/product_cubit/product/product_cubit.dart';
import 'presentation/cubit/product_cubit/product_detail/product_detail_cubit.dart';
import 'presentation/cubit/profile/profile_cubit.dart';
import 'presentation/cubit/splashscreen/splash_screen_cubit.dart';
import 'presentation/cubit/transaction/checkout/checkout_cubit.dart';
import 'presentation/cubit/transaction/history/history_transaction_cubit.dart';
import 'presentation/cubit/transaction/payment/payment_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Data sources
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton<AuthDatasource>(() => AuthDatasourceImpl());
  getIt.registerLazySingleton<ProductDatasource>(() => ProductDatasourceImpl());
  getIt.registerLazySingleton<CartDatasource>(
      () => CartDatasourceImpl(client: getIt()));
  getIt.registerLazySingleton<UserDatasource>(() => UserDatasourceImpl());
  getIt.registerLazySingleton<TransactionDatasource>(
      () => TransactionDatasourceImpl());

  // Repositories
  getIt.registerLazySingleton<AuthRepositories>(
      () => AuthRepositoriesImpl(dataSource: getIt()));
  getIt.registerLazySingleton<ProductRepositories>(
      () => ProductRepositoriesImpl(dataSource: getIt()));
  getIt.registerLazySingleton<CartRepositories>(
      () => CartRepositoriesImpl(dataSource: getIt()));
  getIt.registerLazySingleton<UserRepositories>(
      () => UserRepositoriesImpl(dataSource: getIt()));
  getIt.registerLazySingleton<TransactionRepositories>(() =>
      TransactionRepositoriesImpl(
          dataSource: getIt(), cartDatasource: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => LoginUsecase(getIt()));
  getIt.registerLazySingleton(() => RegisterUsecase(getIt()));

  getIt.registerLazySingleton(() => GetAllProductsUsecase(getIt()));
  getIt.registerLazySingleton(() => AddProductUsecase(getIt()));
  getIt.registerLazySingleton(() => DeleteProductUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdateStockUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdatePriceUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdateProductUsecase(getIt()));
  getIt.registerLazySingleton(() => GetProductByIdUsecase(getIt()));

  getIt.registerLazySingleton(() => GetCartByUserIdUsecase(getIt()));
  getIt.registerLazySingleton(() => AddCartUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdateQuantityUsecase(getIt()));
  getIt.registerLazySingleton(() => DeleteCartUsecase(getIt()));

  getIt.registerLazySingleton(() => GetUserIdUsecase(getIt()));
  getIt.registerLazySingleton(() => CreateUserUsecase(getIt()));

  getIt.registerLazySingleton(() => CreateTransactionUsecase(getIt()));
  getIt.registerLazySingleton(() => GetAllTransactionUsecase(getIt()));

  // Blocs
  getIt.registerFactory(() => SplashScreenCubit());
  getIt.registerFactory(() => BottomNavCubit());
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt(), getIt()));
  getIt.registerFactory(() => CartCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ProductCubit(getIt()));
  getIt.registerFactory(() => ProductDetailCubit(getIt(), getIt()));
  getIt.registerFactory(
      () => CrudProductCubit(getIt(), getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => CheckoutCubit());
  getIt.registerFactory(() => PaymentCubit(getIt()));
  getIt.registerFactory(() => HistoryTransactionCubit(getIt()));
}
