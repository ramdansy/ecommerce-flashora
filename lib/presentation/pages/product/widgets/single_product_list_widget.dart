import 'package:finalproject_flashora/core/common/widgets/common_button.dart';
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
    return Column(
      children: [
        Row(
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
                child: Image.network(product.image.first, fit: BoxFit.contain),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: CommonColor.warningColor),
                              const SizedBox(
                                  width: AppConstant.paddingExtraSmall),
                              Text(
                                '${product.rating} (${product.ratingCount})',
                                style: CommonText.fBodySmall
                                    .copyWith(color: CommonColor.textGrey),
                              ),
                            ],
                          ),
                          Text('  |  ${product.category.toUpperCase()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CommonText.fBodySmall
                                  .copyWith(color: CommonColor.textGrey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstant.paddingMedium),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //stock
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Stock:',
                                style: CommonText.fBodyLarge
                                    .copyWith(color: CommonColor.textGrey),
                              ),
                              TextSpan(
                                text: ' ${product.stock}',
                                style: CommonText.fBodyLarge
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
        ),
        const SizedBox(height: AppConstant.paddingSmall),
        Row(
          children: [
            Expanded(
              child: CommonButtonOutlined(
                  onPressed: () {},
                  text: 'Edit Stock',
                  paddingVertical: 0,
                  color: CommonColor.primary),
            ),
            const SizedBox(width: AppConstant.paddingSmall),
            Expanded(
              child: CommonButtonOutlined(
                  onPressed: () {},
                  text: 'Edit Price',
                  paddingVertical: 0,
                  color: CommonColor.primary),
            ),
            const SizedBox(width: AppConstant.paddingSmall),
            CommonButtonIcon(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: CommonColor.errorColor),
              borderColor: CommonColor.errorColor,
            ),
          ],
        )
      ],
    );
  }
}
