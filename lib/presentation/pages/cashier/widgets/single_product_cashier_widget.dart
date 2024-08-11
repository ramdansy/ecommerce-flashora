import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_icon.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/common_snacbar.dart';
import '../../../../domain/entities/cart_model.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../cubit/cashier/cashier_cubit.dart';
import '../../../cubit/product_cubit/crud_product/crud_product_cubit.dart';

class SingleProductCashierWidget extends StatelessWidget {
  final ProductModel item;
  final CartModel cart;

  const SingleProductCashierWidget({
    super.key,
    required this.item,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
                width: double.infinity,
                height: 180,
                child: Image.network(item.image.first, fit: BoxFit.cover))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstant.paddingMedium),
              Text(item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CommonText.fBodyLarge
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppConstant.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Stock:',
                        style: CommonText.fBodyLarge
                            .copyWith(color: CommonColor.textGrey)),
                    TextSpan(
                        text: ' ${item.stock}',
                        style: CommonText.fBodyLarge
                            .copyWith(fontWeight: FontWeight.bold)),
                  ])),
                  Text(CurrencyHelper.formatCurrencyDouble(item.price),
                      style: CommonText.fBodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: AppConstant.paddingSmall),
        //listen cart
        if (item.stock > 0)
          BlocBuilder<CrudProductCubit, CrudProductState>(
            builder: (context, state) {
              final productCarts = cart.productCart;
              final isReadyInCart = productCarts.isNotEmpty
                  ? productCarts.any((e) => e.productId == item.id)
                  : false;

              if (isReadyInCart) {
                final itemCart =
                    productCarts.firstWhere((e) => e.productId == item.id);
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<CashierCubit>()
                            .deleteItemFromCart(cart.id, item.id);

                        CommonSnacbar.showSuccessSnackbar(
                            context: context, message: 'Delete item from cart');
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(AppConstant.paddingMedium),
                        height: AppConstant.iconNormal * 2,
                        width: AppConstant.iconNormal * 2,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstant.radiusNormal),
                            color: CommonColor.whiteBG),
                        child: CommonIcon.delete,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppConstant.paddingSmall),
                        height: AppConstant.iconNormal * 2,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstant.radiusNormal),
                            color: CommonColor.whiteBG),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (itemCart.quantity > 1) {
                                    context
                                        .read<CashierCubit>()
                                        .decrementQuantity(itemCart.productId);
                                  }
                                },
                                child: SizedBox(
                                    height: AppConstant.iconNormal,
                                    width: AppConstant.iconNormal,
                                    child: CommonIcon.minus)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppConstant.paddingSmall),
                                child: Text(
                                  itemCart.quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: CommonText.fBodyLarge
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                                onTap: () {
                                  if (itemCart.quantity < item.stock) {
                                    context
                                        .read<CashierCubit>()
                                        .incrementQuantity(itemCart.productId);
                                  }
                                },
                                child: SizedBox(
                                    height: AppConstant.iconNormal,
                                    width: AppConstant.iconNormal,
                                    child: CommonIcon.plus)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CommonButtonOutlined(
                  onPressed: () {
                    ProductDetailCartModel productCart = ProductDetailCartModel(
                        productId: item.id, quantity: 1, product: item);

                    context.read<CashierCubit>().addProductToCart(CartModel(
                        id: "", userId: "", productCart: [productCart]));

                    CommonSnacbar.showSuccessSnackbar(
                        context: context, message: 'Success add cart');
                  },
                  text: 'Add to cart',
                );
              }
            },
          ),
      ],
    );
  }
}
