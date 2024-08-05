import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../core/app_preferences.dart';
import '../../routes/app_routes.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial()) {
    loadToken();
  }

  bool _isLogin = false;

  void loadToken() async {
    final token = await AppPreferences.getToken();
    [null, ''].contains(token) ? _isLogin = false : _isLogin = true;
  }

  void compositionLoaded(
      LottieComposition composition, AnimationController controller) {
    emit(SplashScreenLoading());
    controller
      ..duration = composition.duration
      ..forward().whenComplete(() async {
        _isLogin
            ? router.goNamed(RoutesName.home)
            : router.goNamed(RoutesName.login);
      });
  }
}
