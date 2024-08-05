import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_preferences.dart';
import '../../../../domain/entities/user_model.dart';
import '../../../../domain/usecases/auth/register_usecase.dart';
import '../../../../domain/usecases/users/create_user_usecase.dart';
import '../../../routes/app_routes.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUsecase;
  final CreateUserUsecase createUserUsecase;
  RegisterCubit(this.registerUsecase, this.createUserUsecase)
      : super(RegisterInitial());

  final inputFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  final _retypePasswordController = TextEditingController();
  TextEditingController get retypePasswordController =>
      _retypePasswordController;
  final _phoneNumberController = TextEditingController();
  TextEditingController get phoneNumberController => _phoneNumberController;
  final _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;

  final _nameFocus = FocusNode();
  FocusNode get nameFocus => _nameFocus;
  final _emailFocus = FocusNode();
  FocusNode get emailFocus => _emailFocus;
  final _passwordFocus = FocusNode();
  FocusNode get passwordFocus => _passwordFocus;
  final _retypePasswordFocus = FocusNode();
  FocusNode get retypePasswordFocus => _retypePasswordFocus;
  final _phoneFocus = FocusNode();
  FocusNode get phoneFocus => _phoneFocus;
  final _addressFocus = FocusNode();
  FocusNode get addressFocus => _addressFocus;

  void onRegister() async {
    _nameFocus.unfocus();
    _phoneFocus.unfocus();
    _addressFocus.unfocus();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    _retypePasswordFocus.unfocus();

    if (inputFormKey.currentState!.validate()) {
      String uid = '';
      emit(RegisterLoading());

      final resRegisterFirebase = await registerUsecase.execute(
          _emailController.text, passwordController.text);
      resRegisterFirebase.fold(
        (l) => emit(RegisterFailed(message: l.message ?? "")),
        (r) => uid = r!.uid,
      );

      if (uid.isNotEmpty) {
        final resCreateUser = await createUserUsecase.execute(UserModel(
            id: uid,
            name: _nameController.text,
            email: _emailController.text,
            username: _emailController.text.split("@")[0],
            address: _addressController.text,
            phone: _phoneNumberController.text));
        resCreateUser.fold(
          (l) => emit(RegisterFailed(message: l.message ?? "")),
          (r) {
            router.goNamed(RoutesName.home);
            AppPreferences.saveUserId(uid);
            reset();
          },
        );
      }
    }
  }

  void reset() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _retypePasswordController.clear();
    _phoneNumberController.clear();
    _addressController.clear();

    _nameFocus.unfocus();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    _retypePasswordFocus.unfocus();
    _phoneFocus.unfocus();
    _addressFocus.unfocus();

    emit(RegisterInitial());
  }
}
