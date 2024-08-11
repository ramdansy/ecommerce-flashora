import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/common_snacbar.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../../domain/usecases/product/add_product_usecase.dart';
import '../../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../../domain/usecases/product/update_price_usecase.dart';
import '../../../../domain/usecases/product/update_product_usecase.dart';
import '../../../../domain/usecases/product/update_stock_usecase.dart';
import '../product/product_cubit.dart';
import '../product_detail/product_detail_cubit.dart';

part 'crud_product_state.dart';

class CrudProductCubit extends Cubit<CrudProductState> {
  final UpdateStockUsecase updateStock;
  final UpdatePriceUsecase updatePriceUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final AddProductUsecase addProductUsecase;
  final UpdateProductUsecase updateProductUsecase;

  CrudProductCubit(
    this.updateStock,
    this.updatePriceUsecase,
    this.deleteProductUsecase,
    this.addProductUsecase,
    this.updateProductUsecase,
  ) : super(CrudProductInitial());

  void updateStockProduct(
      BuildContext context, String productId, int newStock) async {
    final productCubit = context.read<ProductCubit>();
    emit(UpdatingStock());

    final result = await updateStock.execute(productId, newStock);
    result.fold(
      (l) => emit(UpdateStockError(message: l.message.toString())),
      (r) {
        final selectedProductIndex = productCubit.listProduct
            .indexWhere((element) => element.id == productId);
        productCubit.listProduct[selectedProductIndex].stock = newStock;

        productCubit.emit(ProductLoaded(
            productCubit.listProduct, productCubit.listCategories));
        emit(UpdatedStock());
      },
    );
  }

  void updatePriceProduct(
      BuildContext context, String productId, double newPrice) async {
    final productCubit = context.read<ProductCubit>();
    emit(UpdatingPrice());

    final result = await updatePriceUsecase.execute(productId, newPrice);
    result.fold(
      (left) => emit(UpdatePriceError(message: left.message.toString())),
      (right) {
        final selectedProductIndex = productCubit.listProduct
            .indexWhere((element) => element.id == productId);
        productCubit.listProduct[selectedProductIndex].price = newPrice;

        productCubit.emit(ProductLoaded(
            productCubit.listProduct, productCubit.listCategories));
        emit(UpdatedPrice());
      },
    );
  }

  void addProduct(BuildContext context, ProductModel product) async {
    emit(AddingProduct());

    final result = await addProductUsecase.execute(product);
    result.fold(
      (left) => emit(AddProductError(message: left.message.toString())),
      (right) {
        final productCubit = context.read<ProductCubit>();
        productCubit.fetchAllProducts();
      },
    );

    emit(AddedProduct());
  }

  void deleteProduct(BuildContext context, String productId) async {
    emit(DeletingProduct());

    final result = await deleteProductUsecase.execute(productId);
    result.fold(
      (left) => emit(DeleteProductError(message: left.message.toString())),
      (right) {
        final productCubit = context.read<ProductCubit>();
        final newList = productCubit.listProduct
            .where((element) => element.id != productId)
            .toList();

        productCubit.emit(ProductLoaded(newList, productCubit.listCategories));
        CommonSnacbar.showSuccessSnackbar(
            context: context, message: 'Product deleted successfully');
        context.pop();
        emit(DeletedProduct());
      },
    );
  }

  void updateProduct(BuildContext context, ProductModel product) async {
    emit(UpdatingProduct());

    final result = await updateProductUsecase.execute(product);
    result.fold(
      (left) => emit(UpdateProductError(message: left.message.toString())),
      (right) {
        final productDetailCubit = context.read<ProductDetailCubit>();
        productDetailCubit.getProduct(product.id);

        CommonSnacbar.showSuccessSnackbar(
            context: context, message: 'Product updated successfully');
        context.pop();

        final productCubit = context.read<ProductCubit>();
        final newList = productCubit.listProduct
            .map((e) => e.id == product.id ? product : e)
            .toList();
        productCubit.emit(ProductLoaded(newList, productCubit.listCategories));

        emit(UpdatedProduct());
      },
    );
  }
}
