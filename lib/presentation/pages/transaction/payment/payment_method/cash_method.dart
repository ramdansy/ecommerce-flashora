import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';
import '../../../../../core/common/utils/currency_helper.dart';
import '../../../../../core/common/widgets/common_text_input.dart';
import '../../../../cubit/transaction/payment/payment_cubit.dart';

class CashMethod extends StatelessWidget {
  const CashMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final paymentCubit = context.read<PaymentCubit>();
        return ListView(
          children: [
            Text('Paid Amount',
                style: CommonText.fBodyLarge
                    .copyWith(color: CommonColor.textGrey)),
            const SizedBox(height: AppConstant.paddingSmall),
            Form(
              key: paymentCubit.formKey,
              child: CommonTextInput(
                textEditingController: paymentCubit.paidAmountController,
                focusNode: paymentCubit.paidAmountFocus,
                hintText: '0',
                textAlign: TextAlign.end,
                maxLines: 1,
                prefix: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstant.paddingNormal),
                    child: Text('Rp.', style: CommonText.fHeading5)),
                textInputAction: TextInputAction.next,
                onFieldSubmit: (_) {},
                textInputType: TextInputType.number,
                textStyle: CommonText.fHeading5,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(
                      thousandSeparator: ThousandSeparator.Period,
                      mantissaLength: 0)
                ],
              ),
            ),
            const SizedBox(height: AppConstant.paddingNormal),
            Wrap(
              spacing: AppConstant.paddingSmall,
              runSpacing: AppConstant.paddingSmall,
              children: List.generate(
                paymentCubit.staticPrice.length,
                (index) => InkWell(
                  onTap: () => paymentCubit.selectPrice(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstant.paddingSmall,
                        horizontal: AppConstant.paddingNormal),
                    decoration: BoxDecoration(
                      color: CommonColor.whiteBG,
                      borderRadius:
                          BorderRadius.circular(AppConstant.radiusNormal),
                      border: Border.all(
                          color: CommonColor.borderColorDisable, width: .5),
                    ),
                    child: Text(
                        CurrencyHelper.formatCurrencyDouble(
                            paymentCubit.staticPrice[index].price.toDouble()),
                        style: CommonText.fBodyLarge
                            .copyWith(fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
