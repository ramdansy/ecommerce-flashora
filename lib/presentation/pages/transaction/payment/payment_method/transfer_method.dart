import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';
import '../../../../cubit/transaction/payment/payment_cubit.dart';

class TransferMethod extends StatelessWidget {
  const TransferMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Method',
                  style: CommonText.fBodyLarge
                      .copyWith(color: CommonColor.textGrey)),
              const SizedBox(height: AppConstant.paddingSmall),
              Expanded(
                child: ListView.separated(
                  itemCount: state.paymentMethod.length,
                  itemBuilder: (context, index) {
                    final item = state.paymentMethod[index];
                    return InkWell(
                      onTap: () => context
                          .read<PaymentCubit>()
                          .selectPaymentMethod(item),
                      child: Container(
                        padding: const EdgeInsets.all(AppConstant.paddingSmall),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConstant.radiusNormal),
                          color: item.isSelected
                              ? CommonColor.primary.withOpacity(.1)
                              : CommonColor.whiteBG,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(
                                  AppConstant.paddingExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppConstant.radiusNormal),
                                color: CommonColor.whiteBG,
                              ),
                              child: Image.asset(
                                item.assetsImage,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: AppConstant.paddingNormal),
                            Expanded(
                              child:
                                  Text(item.name, style: CommonText.fBodyLarge),
                            ),
                            const SizedBox(width: AppConstant.paddingNormal),
                            Icon(
                                item.isSelected
                                    ? Icons.radio_button_on_outlined
                                    : Icons.radio_button_off_outlined,
                                size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppConstant.paddingSmall),
                ),
              ),
              const SizedBox(height: AppConstant.paddingNormal),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
