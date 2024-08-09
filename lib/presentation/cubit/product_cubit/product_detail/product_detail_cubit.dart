import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/product_model.dart';
import '../../../../domain/usecases/product/get_product_by_id_usecase.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUsecase getProductByIdUsecase;

  ProductDetailCubit(this.getProductByIdUsecase)
      : super(ProductDetailInitial());

  ProductModel? product;

  void getProduct(String productId) {
    emit(ProductDetailLoading());

    Future.delayed(const Duration(seconds: 1), () async {
      final res = await getProductByIdUsecase.execute(productId);
      res.fold(
        (left) => emit(ProductDetailError(left.message.toString())),
        (right) {
          product = right;
          emit(ProductDetailLoaded(right));
        },
      );
    });
  }
}
