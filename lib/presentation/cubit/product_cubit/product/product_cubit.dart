import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/utils/notification_helper.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../../domain/usecases/product/get_all_products_usecase.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProductsUsecase getAllProducts;
  ProductCubit(this.getAllProducts) : super(ProductInitial());

  List<ProductModel> _listProduct = [];

  final List<Category> _categories = [
    Category(name: 'All', selected: true),
    Category(name: 'Shirt', selected: false),
    Category(name: 'Shoes', selected: false),
    Category(name: 'Pants', selected: false),
    Category(name: 'Accessories', selected: false),
    Category(name: 'Dress', selected: false),
    Category(name: 'Jacket', selected: false),
    Category(name: 'Hoodie', selected: false),
  ];
  List<Category> get categories => _categories;

  Future<void> fetchAllProducts() async {
    emit(ProductLoading());

    final resProduct = await getAllProducts.execute();
    resProduct.fold(
      (left) => emit(ProductError(left.message.toString())),
      (right) {
        _listProduct = right;
        emit(ProductLoaded(_listProduct, _categories));
      },
    );
  }

  void searchProducts(String value) {
    emit(ProductLoading());

    List<ProductModel> newProducts = _listProduct
        .where(
          (element) =>
              element.title.toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    emit(ProductLoaded(newProducts, _categories));
  }

  void filterProducts(Category categories) {
    emit(ProductLoading());

    final newCategories = _categories
        .map((element) => element.name == categories.name
            ? element.copyWith(selected: true)
            : element.copyWith(selected: false))
        .toList();

    if (categories.name.toLowerCase() == 'all') {
      emit(ProductLoaded(_listProduct, _categories));
      return;
    }

    List<ProductModel> newProducts = _listProduct
        .where((element) =>
            element.category.toLowerCase() == categories.name.toLowerCase())
        .toList();

    emit(ProductLoaded(newProducts, newCategories));
  }

  void showNotif() async {
    NotificationHelper.payload.value = '';

    /// kirim notification
    await NotificationHelper.flutterLocalNotificationsPlugin.show(
      Random().nextInt(99),
      'Pesanan Sedang Dalam Perjalanan',
      'Pesanan 09127989013 sedang dalam perjalanan',
      NotificationHelper.notificationDetails,
    );
  }
}

class Category {
  final String name;
  final bool selected;
  Category({required this.name, required this.selected});

  Category copyWith({bool? selected}) {
    return Category(
      name: name,
      selected: selected ?? this.selected,
    );
  }
}
