import 'package:flutter/material.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../domain/entities/product_model.dart';

class SingleProductListWidget extends StatelessWidget {
  final ProductModel product;
  const SingleProductListWidget({super.key, required this.product});

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
            child: Image.network(product.image.first, fit: BoxFit.cover),
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
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CommonText.fBodyLarge
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(product.category.toUpperCase(),
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
                  //rating
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: CommonColor.warningColor),
                        const SizedBox(width: AppConstant.paddingExtraSmall),
                        Text(
                          '${product.rating} (${product.ratingCount})',
                          style: CommonText.fBodySmall
                              .copyWith(color: CommonColor.textGrey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingNormal),
                  Text(
                    CurrencyHelper.formatCurrencyDouble(product.price),
                    style: CommonText.fHeading5
                        .copyWith(color: CommonColor.primary),
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
