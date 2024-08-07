import 'package:finalproject_flashora/domain/usecases/cart/delete_cart_usecase.dart';
import 'package:finalproject_flashora/domain/usecases/product/update_price_usecase.dart';
import 'package:finalproject_flashora/domain/usecases/product/update_stock_usecase.dart';
import 'package:finalproject_flashora/presentation/cubit/product_cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'crud_product_state.dart';

class CrudProductCubit extends Cubit<CrudProductState> {
  final UpdateStockUsecase updateStock;
  final UpdatePriceUsecase updatePriceUsecase;
  final DeleteCartUsecase deleteCartUsecase;

  CrudProductCubit(
      this.updateStock, this.updatePriceUsecase, this.deleteCartUsecase)
      : super(CrudProductInitial());

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
}
