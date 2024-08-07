part of 'crud_product_cubit.dart';

sealed class CrudProductState extends Equatable {
  const CrudProductState();

  @override
  List<Object> get props => [];
}

final class CrudProductInitial extends CrudProductState {}

final class UpdatingStock extends CrudProductState {}

final class UpdatedStock extends CrudProductState {}

final class UpdateStockError extends CrudProductState {
  final String message;
  const UpdateStockError({required this.message});
}
