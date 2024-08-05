import 'package:flutter/material.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';
import '../../../../../core/common/utils/currency_helper.dart';
import '../../../../../domain/entities/product_model.dart';
import '../../../../../domain/entities/user_model.dart';
import '../checkout_screen.dart';

class SingleListProductCheckoutWidget extends StatelessWidget {
  final ProductCheckout productCheckout;
  const SingleListProductCheckoutWidget({
    super.key,
    required this.productCheckout,
  });

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
          constraints: const BoxConstraints(maxHeight: 100, maxWidth: 80),
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
            aspectRatio: 1 / 1.25,
            child: Image.network(
              productCheckout.product.image.first,
              fit: BoxFit.cover,
            ),
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
                    productCheckout.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CommonText.fBodyLarge
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(productCheckout.product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CommonText.fBodySmall
                          .copyWith(color: CommonColor.textGrey)),
                ],
              ),
              const SizedBox(height: AppConstant.paddingMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CurrencyHelper.formatCurrencyDouble(
                        productCheckout.product.price),
                    style: CommonText.fHeading5
                        .copyWith(color: CommonColor.primary),
                  ),
                  const SizedBox(width: AppConstant.paddingNormal),
                  Text(
                    'x${productCheckout.quantity}',
                    style: CommonText.fBodyLarge,
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

class CheckoutModel {
  final UserModel user;
  final List<ProductModel> listProduct;

  get totalPrice => listProduct
      .map((e) => e.price)
      .reduce((value, element) => value + element);

  CheckoutModel({required this.user, required this.listProduct});
}
