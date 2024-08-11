import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/utils/currency_helper.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../cubit/bottom_nav/bottom_nav_cubit.dart';
import '../../cubit/cashier/cashier_cubit.dart';
import '../../widgets/empty_widget.dart';
import '../product/widgets/category_list_widget.dart';
import 'widgets/product_cashier_placeholder.dart';
import 'widgets/single_product_cashier_widget.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  @override
  void initState() {
    context.read<CashierCubit>().fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        backgroundColor: CommonColor.white,
        scrolledUnderElevation: 0.0,
        title: Text('Select Product', style: CommonText.fHeading2),
      ),
      body: BlocBuilder<CashierCubit, CashierState>(
        builder: (context, state) {
          if (state is CashierLoaded) {
            int totalItem = state.cart!.productCart.isNotEmpty
                ? state.cart!.productCart
                    .map((e) => e.quantity)
                    .reduce((a, b) => a + b)
                : 0;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppConstant.paddingNormal,
                      bottom: AppConstant.paddingNormal),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: CategoryListWidget(
                          listCategories: state.categories, isCashier: true)),
                ),
                Expanded(
                  child: state.products.isNotEmpty
                      ? GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.only(
                              left: AppConstant.paddingNormal,
                              right: AppConstant.paddingNormal,
                              bottom: AppConstant.paddingNormal),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppConstant.paddingNormal,
                                  mainAxisSpacing: AppConstant.paddingNormal,
                                  childAspectRatio: 9 / 17),
                          shrinkWrap: true,
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final item = state.products[index];
                            return SingleProductCashierWidget(
                                item: item, cart: state.cart!);
                          },
                        )
                      : const Column(children: [
                          EmptyWidget(
                            message: 'Cart is empty',
                            margin: EdgeInsets.symmetric(
                                horizontal: AppConstant.paddingNormal),
                          )
                        ]),
                ),
                if (state.cart!.productCart.isNotEmpty)
                  Container(
                    decoration: const BoxDecoration(
                      color: CommonColor.whiteBG,
                      border: Border(
                          top: BorderSide(
                              color: CommonColor.borderColorDisable,
                              width: 1.0)),
                    ),
                    padding: const EdgeInsets.all(AppConstant.paddingNormal),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$totalItem Items',
                                  style: CommonText.fBodyLarge),
                              Text(
                                  CurrencyHelper.formatCurrencyDouble(
                                      state.cart!.totalPrice),
                                  style: CommonText.fHeading5),
                            ],
                          ),
                        ),
                        Expanded(
                            child: CommonButtonFilled(
                                onPressed: () => context
                                    .read<BottomNavCubit>()
                                    .navigateTo(index: 2),
                                text: 'Goto Cart'))
                      ],
                    ),
                  ),
              ],
            );
          }

          if (state is CashierLoading) {
            return const ProductCashierPlaceholder();
          }
          return Container();
        },
      ),
    );
  }
}
