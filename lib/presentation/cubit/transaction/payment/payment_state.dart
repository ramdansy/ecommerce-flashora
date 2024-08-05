part of 'payment_cubit.dart';

class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final int indexTabbar;
  final List<PaymentMethod> paymentMethod;

  const PaymentLoaded({this.indexTabbar = 0, this.paymentMethod = const []});

  @override
  List<Object> get props => [indexTabbar, paymentMethod];

  PaymentLoaded copyWith(
      {int? indexTabbar, List<PaymentMethod>? paymentMethod}) {
    return PaymentLoaded(
      indexTabbar: indexTabbar ?? this.indexTabbar,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
