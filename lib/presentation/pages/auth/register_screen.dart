import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/enum/common_form_validate_type.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../core/common/widgets/common_snacbar.dart';
import '../../../core/common/widgets/common_text_input.dart';
import '../../../dependency_injection.dart';
import '../../cubit/auth/register/register_cubit.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      body: BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(AppConstant.paddingNormal,
                    80, AppConstant.paddingNormal, AppConstant.paddingLarge),
                color: CommonColor.whiteBG,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Start your shopping journey with us. ',
                      style: CommonText.fBodyLarge
                          .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Sign up for access to the latest products and special promotions!',
                      style: CommonText.fBodyLarge
                          .copyWith(fontSize: 24, color: CommonColor.textGrey),
                    ),
                  ]),
                )),
            Expanded(child: _buildForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailed) {
          CommonSnacbar.showErrorSnackbar(
              context: context, message: state.message);
        }
      },
      builder: (context, state) {
        final registerCubit = context.read<RegisterCubit>();

        return Form(
          key: registerCubit.inputFormKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstant.paddingNormal),
            children: [
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.nameController,
                focusNode: registerCubit.nameFocus,
                hintText: 'Name',
                textInputAction: TextInputAction.next,
                obsecureText: false,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                validators: const [CommonFormValidateType.noEmpty],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.phoneNumberController,
                focusNode: registerCubit.phoneFocus,
                hintText: 'Phone Number',
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.phone,
                validators: const [CommonFormValidateType.noEmpty],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.addressController,
                focusNode: registerCubit.addressFocus,
                hintText: 'Address',
                textInputAction: TextInputAction.done,
                maxLines: 3,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                validators: const [CommonFormValidateType.noEmpty],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.emailController,
                focusNode: registerCubit.emailFocus,
                hintText: 'Email',
                textInputAction: TextInputAction.next,
                obsecureText: false,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                validators: const [
                  CommonFormValidateType.noEmpty,
                  CommonFormValidateType.email,
                ],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.passwordController,
                focusNode: registerCubit.passwordFocus,
                hintText: 'Password',
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                obsecureText: true,
                validators: const [CommonFormValidateType.noEmpty],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: registerCubit.retypePasswordController,
                focusNode: registerCubit.retypePasswordFocus,
                hintText: 'Retype Password',
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                obsecureText: true,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppConstant.textErrorEmpty
                        .replaceAll('@fieldName', 'Retype Password');
                  }
                  if (value != registerCubit.passwordController.text) {
                    return AppConstant.textErrorPasswordNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonButtonFilled(
                onPressed: () => registerCubit.onRegister(),
                text: 'Sign up',
                isLoading: state is RegisterLoading,
                paddingVertical: AppConstant.paddingNormal,
              ),
              const SizedBox(height: AppConstant.paddingExtraLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: CommonText.fBodyLarge),
                ],
              ),
              const SizedBox(height: AppConstant.paddingNormal),
              CommonButtonOutlined(
                onPressed: () => context.goNamed(RoutesName.login),
                text: 'Sign in',
                paddingVertical: AppConstant.paddingNormal,
              ),
              const SizedBox(height: AppConstant.paddingLarge),
            ],
          ),
        );
      },
    );
  }
}
