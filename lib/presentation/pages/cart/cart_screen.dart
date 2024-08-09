import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_shimmer.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/utils/currency_helper.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../widgets/empty_widget.dart';
import 'widgets/single_cart_list_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: CommonColor.white,
        scrolledUnderElevation: 0.0,
        title: Text('Carts', style: CommonText.fHeading2),
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return RefreshIndicator(
              child: _buildBody(state),
              onRefresh: () async {
                context.read<CartCubit>().loadCart();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(CartState state) {
    if (state is CartError) {
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Center(child: Text(state.message));
          });
    }

    if (state is CartEmpty) {
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return const EmptyWidget(message: 'Cart is empty');
        },
      );
    }

    if (state is CartLoaded) {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstant.paddingNormal),
              itemCount: state.cart.productCart.length,
              itemBuilder: (context, index) {
                return SingleCartListWidget(
                    cart: state.cart, product: state.cart.productCart[index]);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppConstant.paddingLarge),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppConstant.paddingNormal),
            decoration: const BoxDecoration(
              color: CommonColor.whiteBG,
              border: Border(
                  top: BorderSide(
                      color: CommonColor.borderColorDisable, width: 1.0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: CommonText.fBodySmall
                            .copyWith(color: CommonColor.textGrey),
                      ),
                      Text(
                        CurrencyHelper.formatCurrencyDouble(
                            state.cart.totalPrice),
                        style: CommonText.fHeading4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstant.paddingSmall),
                Expanded(
                  child: CommonButtonFilled(
                    onPressed: () => context.read<CartCubit>().gotoCheckout(),
                    text: 'Checkout',
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstant.paddingNormal),
      itemCount: 10,
      itemBuilder: (context, index) {
        return CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 100,
        );
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstant.paddingNormal),
    );
  }
}
