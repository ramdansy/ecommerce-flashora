import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../dependency_injection.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/enum/common_form_validate_type.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../core/common/widgets/common_snacbar.dart';
import '../../../core/common/widgets/common_text_input.dart';
import '../../cubit/auth/login/login_cubit.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      body: BlocProvider(
        create: (context) => getIt<LoginCubit>(),
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
                      text: 'Welcome Back! ',
                      style: CommonText.fBodyLarge
                          .copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Unlock thousands of exciting products and enjoy exclusive offers just for you.',
                      style: CommonText.fBodyLarge
                          .copyWith(fontSize: 28, color: CommonColor.textGrey),
                    ),
                  ]),
                )),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.goNamed(RoutesName.home);
        }

        if (state is LoginFailed) {
          CommonSnacbar.showErrorSnackbar(
              context: context, message: state.message);
        }
      },
      builder: (context, state) {
        final loginCubit = context.read<LoginCubit>();

        return Form(
          key: loginCubit.inputFormKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstant.paddingNormal),
            children: [
              const SizedBox(height: AppConstant.paddingLarge),
              CommonTextInput(
                textEditingController: loginCubit.emailController,
                focusNode: loginCubit.emailFocus,
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
                textEditingController: loginCubit.passwordController,
                focusNode: loginCubit.passwordFocus,
                hintText: 'Password',
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onFieldSubmit: (value) {},
                textInputType: TextInputType.text,
                obsecureText: true,
                validators: const [
                  CommonFormValidateType.noEmpty,
                ],
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              CommonButtonFilled(
                onPressed: () => loginCubit.onLogin(),
                text: 'Sign in',
                isLoading: state is LoginLoading,
                paddingVertical: AppConstant.paddingNormal,
              ),
              const SizedBox(height: AppConstant.paddingExtraLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?', style: CommonText.fBodyLarge),
                ],
              ),
              const SizedBox(height: AppConstant.paddingNormal),
              CommonButtonOutlined(
                onPressed: () => context.goNamed(RoutesName.register),
                text: 'Sign up',
                paddingVertical: AppConstant.paddingNormal,
              ),
            ],
          ),
        );
      },
    );
  }
}
