part of 'crud_product_cubit.dart';

sealed class CrudProductState extends Equatable {
  const CrudProductState();

  @override
  List<Object> get props => [];
}

final class CrudProductInitial extends CrudProductState {}

final class UpdatingStock extends CrudProductState {}

final class UpdatedStock extends CrudProductState {}

final class UpdatingPrice extends CrudProductState {}

final class UpdatedPrice extends CrudProductState {}

final class AddingProduct extends CrudProductState {}

final class AddedProduct extends CrudProductState {}

final class DeletingProduct extends CrudProductState {}

final class DeletedProduct extends CrudProductState {}

final class UpdatingProduct extends CrudProductState {}

final class UpdatedProduct extends CrudProductState {}

final class UpdateProductError extends CrudProductState {
  final String message;
  const UpdateProductError({required this.message});
}

final class AddProductError extends CrudProductState {
  final String message;
  const AddProductError({required this.message});
}

final class UpdateStockError extends CrudProductState {
  final String message;
  const UpdateStockError({required this.message});
}

final class UpdatePriceError extends CrudProductState {
  final String message;
  const UpdatePriceError({required this.message});
}

final class DeleteProductError extends CrudProductState {
  final String message;
  const DeleteProductError({required this.message});
}

final class CrudLoading extends CrudProductState {}

final class CrudSuccess extends CrudProductState {}

final class CrudError extends CrudProductState {
  final String message;
  const CrudError({required this.message});
}
