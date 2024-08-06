import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_shimmer.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../../domain/entities/user_model.dart';
import '../../../cubit/profile/profile_cubit.dart';
import '../../../cubit/transaction/checkout/checkout_cubit.dart';
import 'widgets/single_list_product_checkout_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ProductCheckout> productCheckout;
  const CheckoutScreen({super.key, required this.productCheckout});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user;

    return Scaffold(
      backgroundColor: CommonColor.whiteBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CommonColor.white,
        shape: const Border(
            bottom: BorderSide(color: CommonColor.textGrey, width: 0.1)),
        title: Text('Checkout', style: CommonText.fHeading4),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      user = state.user;

                      return Container(
                        padding:
                            const EdgeInsets.all(AppConstant.paddingNormal),
                        color: CommonColor.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery to',
                                style: CommonText.fBodySmall
                                    .copyWith(color: CommonColor.textGrey)),
                            const SizedBox(height: AppConstant.paddingNormal),
                            Text(state.user.name.toUpperCase(),
                                style: CommonText.fBodyLarge
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text(state.user.address,
                                style: CommonText.fBodyLarge),
                            const SizedBox(height: AppConstant.paddingNormal),
                            Text(
                                'Estimated received at: ${DateFormat.yMMMMEEEEd().format(DateTime.now().add(const Duration(days: 3)))}',
                                style: CommonText.fBodySmall.copyWith(
                                    color: CommonColor.textGrey,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }

                    if (state is ProfileLoading) {
                      return CommonShimmer(
                          height: 150,
                          borderRadius: BorderRadius.zero,
                          width: MediaQuery.of(context).size.width);
                    }

                    return Container();
                  },
                ),
                const SizedBox(height: AppConstant.paddingExtraSmall),
                Container(
                  padding: const EdgeInsets.all(AppConstant.paddingNormal),
                  color: CommonColor.white,
                  constraints: const BoxConstraints(minHeight: 0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.productCheckout.length,
                    itemBuilder: (context, index) {
                      return SingleListProductCheckoutWidget(
                          productCheckout: widget.productCheckout[index]);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstant.paddingNormal),
                  ),
                ),
                const SizedBox(height: AppConstant.paddingNormal),
              ],
            ),
          ),

          //action
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(AppConstant.paddingNormal),
            decoration: const BoxDecoration(
              color: CommonColor.white,
              border: Border(
                  top: BorderSide(color: CommonColor.borderButton, width: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Payment',
                          style: CommonText.fBodySmall
                              .copyWith(color: CommonColor.textGrey)),
                      Text(
                          CurrencyHelper.formatCurrencyDouble(widget
                              .productCheckout
                              .map((e) => e.product.price * e.quantity)
                              .reduce((value, element) => value + element)),
                          style: CommonText.fHeading4),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstant.paddingSmall),
                Expanded(
                    child: CommonButtonFilled(
                        onPressed: () => context
                            .read<CheckoutCubit>()
                            .createOrder(user!, widget.productCheckout),
                        text: 'Payment Now')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
