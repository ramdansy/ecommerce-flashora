import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_preferences.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;

  LoginCubit(this.loginUsecase) : super(LoginInitial());

  final inputFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final _emailFocus = FocusNode();
  FocusNode get emailFocus => _emailFocus;
  final _passwordFocus = FocusNode();
  FocusNode get passwordFocus => _passwordFocus;

  void onLogin() async {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();

    if (inputFormKey.currentState!.validate()) {
      emit(LoginLoading());

      //login action
      final resLogin = await loginUsecase.execute(
          _emailController.text, _passwordController.text);
      resLogin.fold(
        (l) => emit(LoginFailed(message: l.message ?? "")),
        (r) async {
          final idToken = await r?.getIdToken();
          await AppPreferences.saveToken(idToken ?? "");
          await AppPreferences.saveUserId(r?.uid ?? "");
          emit(LoginSuccess());
        },
      );
    }
  }
}
