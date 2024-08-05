import 'package:finalproject_flashora/core/common/widgets/common_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../cubit/transaction/payment/payment_cubit.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentModel paymentModel;
  const PaymentScreen({super.key, required this.paymentModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
          backgroundColor: CommonColor.white,
          title: Text('Payment', style: CommonText.fHeading4),
          centerTitle: true,
          scrolledUnderElevation: 0.0),
      body: BlocProvider(
        create: (buildContext) => getIt<PaymentCubit>(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.paddingNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  final paymentCubit = context.read<PaymentCubit>();

                  return Row(
                    children: List.generate(
                      paymentCubit.paymentType.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right:
                                  index != paymentCubit.paymentType.length - 1
                                      ? AppConstant.paddingSmall
                                      : 0),
                          child: InputChip(
                            onPressed: () => paymentCubit.selectPayment(index),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(paymentCubit.paymentType[index].name,
                                  textAlign: TextAlign.center,
                                  style: CommonText.fBodySmall.copyWith(
                                      color: paymentCubit
                                              .paymentType[index].selected
                                          ? CommonColor.white
                                          : CommonColor.textGrey)),
                            ),
                            backgroundColor:
                                paymentCubit.paymentType[index].selected
                                    ? CommonColor.primary
                                    : CommonColor.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstant.radiusNormal),
                              side: BorderSide(
                                  color:
                                      paymentCubit.paymentType[index].selected
                                          ? CommonColor.primary
                                          : CommonColor.borderColorDisable),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstant.paddingNormal),
              const Line(),
              const SizedBox(height: AppConstant.paddingNormal),
              Row(
                children: [
                  Expanded(
                    child: Text('Total Payment',
                        style: CommonText.fBodyLarge
                            .copyWith(color: CommonColor.textGrey)),
                  ),
                  const SizedBox(width: AppConstant.paddingNormal),
                  Text(
                      CurrencyHelper.formatCurrencyDouble(
                          paymentModel.totalPrice),
                      style: CommonText.fHeading5
                          .copyWith(color: CommonColor.primary)),
                ],
              ),
              const SizedBox(height: AppConstant.paddingNormal),
              BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  final paymentCubit = context.read<PaymentCubit>();
                  if (state is PaymentLoaded) {
                    return Expanded(
                        child: paymentCubit.listMethod[state.indexTabbar]);
                  }
                  return Container();
                },
              ),
              const Line(),
              const SizedBox(height: AppConstant.paddingNormal),
              BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                if (state is PaymentLoaded) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CommonButtonFilled(
                        onPressed: () => context
                            .read<PaymentCubit>()
                            .createTransaction(
                                paymentModel, state.indexTabbar, context),
                        text: state.indexTabbar == 0
                            ? 'Pay Now'
                            : 'Confirm Payment'),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
