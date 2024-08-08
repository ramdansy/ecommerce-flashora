import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/common/common_color.dart';
import '../../../../../../core/common/common_icon.dart';
import '../../../../core/app_constant.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../domain/entities/cart_model.dart';
import '../../../cubit/cart/cart_cubit.dart';

class SingleCartListWidget extends StatelessWidget {
  final CartModel cart;
  final ProductDetailCartModel product;

  const SingleCartListWidget(
      {super.key, required this.cart, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.radiusLarge),
            color: CommonColor.whiteBG,
          ),
          clipBehavior: Clip.hardEdge,
          constraints: const BoxConstraints(maxHeight: 100, maxWidth: 80),
          child: AspectRatio(
            aspectRatio: 1 / 1.25,
            child:
                Image.network(product.product!.image.first, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.product!.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CommonText.fBodyLarge
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(product.product!.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CommonText.fBodySmall
                          .copyWith(color: CommonColor.textGrey)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      CurrencyHelper.formatCurrencyDouble(
                          product.product!.price),
                      style: CommonText.fHeading5
                          .copyWith(color: CommonColor.primary),
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingNormal),

                  //action cart
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _showDeleteDialog(
                              context, cart.id, product.productId);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.all(AppConstant.paddingSmall),
                          height: AppConstant.iconExtraLarge,
                          width: AppConstant.iconExtraLarge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppConstant.radiusNormal),
                              color: CommonColor.whiteBG),
                          child: CommonIcon.delete,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(AppConstant.paddingSmall),
                        height: AppConstant.iconExtraLarge,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstant.radiusNormal),
                            color: CommonColor.whiteBG),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (product.quantity > 1) {
                                    context
                                        .read<CartCubit>()
                                        .decrementQuantity(product.productId);
                                  }
                                },
                                child: CommonIcon.minus),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstant.paddingSmall),
                              child: Text(
                                product.quantity.toString(),
                                style: CommonText.fBodyLarge
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                                onTap: () {
                                  context
                                      .read<CartCubit>()
                                      .incrementQuantity(product.productId);
                                },
                                child: CommonIcon.plus),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

void _showDeleteDialog(BuildContext context, String cartId, String productId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: CommonColor.whiteBG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CommonColor.redSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CommonIcon.getImageFromAsset('delete.svg',
                      color: CommonColor.redSolid)),
            ),
            const SizedBox(height: 12),
            const Text(
              "Delete Item",
              style: TextStyle(
                  color: CommonColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete \nthis item from your cart?",
          textAlign: TextAlign.center,
          style: TextStyle(color: CommonColor.black, fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.redAccent),
                      color: Colors.transparent,
                    ),
                    child: const Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context
                        .read<CartCubit>()
                        .deleteItemFromCart(cartId, productId);
                    Navigator.pop(dialogContext);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.redAccent),
                        color: Colors.redAccent),
                    child: const Text(
                      'Yes, Delete',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: CommonColor.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
