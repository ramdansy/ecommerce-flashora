import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';
import '../../../../../core/common/utils/currency_helper.dart';
import '../../../../../domain/entities/payment_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/item_status_transaction_widget.dart';

class SingleHistoryTransactionWidget extends StatelessWidget {
  const SingleHistoryTransactionWidget({
    super.key,
    required this.item,
  });

  final PaymentModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.pushNamed(RoutesName.historyTransactionDetail, extra: item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstant.radiusExtraLarge),
          color: CommonColor.white,
          border: Border.all(color: CommonColor.borderColorDisable),
        ),
        margin: const EdgeInsets.only(bottom: AppConstant.paddingNormal),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstant.paddingMedium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConstant.radiusLarge),
                      color: CommonColor.whiteBG,
                    ),
                    clipBehavior: Clip.hardEdge,
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 80),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.25,
                      child: Image.network(
                          item.listProducts.first.product.image.first,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.listProducts.first.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CommonText.fBodyLarge
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(item.listProducts.first.product.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CommonText.fBodySmall
                                .copyWith(color: CommonColor.textGrey)),
                        const SizedBox(height: AppConstant.paddingSmall),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${item.listProducts.first.quantity} x ',
                                style: CommonText.fBodyLarge),
                            TextSpan(
                              text: CurrencyHelper.formatCurrencyDouble(
                                  item.listProducts.first.product.price),
                              style: CommonText.fHeading5
                                  .copyWith(color: CommonColor.primary),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (item.listProducts.length > 1)
              Padding(
                padding: const EdgeInsets.all(AppConstant.paddingSmall),
                child: Text(
                  '+${item.listProducts.length - 1} Products',
                  style: CommonText.fBodyLarge
                      .copyWith(color: CommonColor.textGrey),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstant.paddingMedium,
                  vertical: AppConstant.paddingSmall),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: CommonColor.borderColorDisable)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Payment',
                          style: CommonText.fBodySmall
                              .copyWith(color: CommonColor.textGrey),
                        ),
                        Text(
                            CurrencyHelper.formatCurrencyDouble(
                                item.totalPrice),
                            style: CommonText.fHeading5),
                      ]),
                  ItemStatusTransactionWidget(status: item.status!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
