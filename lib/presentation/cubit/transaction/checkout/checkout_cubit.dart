import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/utils/fcm_helper.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void createOrder() {
    FcmHelper.sendNotification(
      'Test Title',
      'This is a test notification.',
    );
    // await FirebaseMessaging.instance.sendMessage(
    //   to: '',
    //   notification: NotificationMessage(
    //     title: 'Pesanan Baru',
    //     body: 'Pesanan Anda sudah dibuat.',
    //   ),
    // );
  }
}
