import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/utils/notification_helper.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../../domain/usecases/product/get_all_products_usecase.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProductsUsecase getAllProducts;

  ProductCubit(this.getAllProducts) : super(ProductInitial());

  final _stockController = TextEditingController();
  TextEditingController get stockController => _stockController;
  final stockFocusNode = FocusNode();

  List<ProductModel> listProduct = [];

  final List<Category> listCategories = [
    Category(name: 'All', selected: true),
    Category(name: 'Shirt', selected: false),
    Category(name: 'Shoes', selected: false),
    Category(name: 'Pants', selected: false),
    Category(name: 'Accessories', selected: false),
    Category(name: 'Dress', selected: false),
    Category(name: 'Jacket', selected: false),
    Category(name: 'Hoodie', selected: false),
  ];

  Future<void> fetchAllProducts() async {
    emit(ProductLoading());

    final resProduct = await getAllProducts.execute();
    resProduct.fold(
      (left) => emit(ProductError(left.message.toString())),
      (right) {
        listProduct = right;
        emit(ProductLoaded(listProduct, listCategories));
      },
    );
  }

  void searchProducts(String value) {
    emit(ProductLoading());

    List<ProductModel> newProducts = listProduct
        .where(
          (element) =>
              element.title.toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    emit(ProductLoaded(newProducts, listCategories));
  }

  void filterProducts(Category categories) {
    emit(ProductLoading());

    final newCategories = listCategories
        .map((element) => element.name == categories.name
            ? element.copyWith(selected: true)
            : element.copyWith(selected: false))
        .toList();

    if (categories.name.toLowerCase() == 'all') {
      emit(ProductLoaded(listProduct, listCategories));
      return;
    }

    List<ProductModel> newProducts = listProduct
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
