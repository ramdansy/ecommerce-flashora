import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/utils/currency_helper.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../core/common/widgets/common_snacbar.dart';
import '../../../domain/entities/product_model.dart';
import '../../cubit/product_cubit/product_detail/product_detail_cubit.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        backgroundColor: CommonColor.white,
        shape: const Border(
            bottom: BorderSide(color: CommonColor.textGrey, width: 0.1)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(product.image.first, fit: BoxFit.cover),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstant.paddingNormal),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputChip(
                    label: Text(product.category.toUpperCase(),
                        style: CommonText.fCaptionLarge
                            .copyWith(color: CommonColor.black)),
                    backgroundColor: CommonColor.white,
                    disabledColor: CommonColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstant.radiusNormal),
                      side: const BorderSide(
                          color: CommonColor.borderColorDisable),
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Stock:',
                            style: CommonText.fBodyLarge
                                .copyWith(color: CommonColor.textGrey)),
                        TextSpan(
                            text: ' ${product.stock}',
                            style: CommonText.fHeading5),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: AppConstant.paddingSmall),
              Text(
                product.title,
                style: CommonText.fHeading5,
              ),
              const SizedBox(height: AppConstant.paddingSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: CommonColor.warningColor),
                      const SizedBox(width: AppConstant.paddingExtraSmall),
                      Text(
                        '${product.rating < 1 ? 0 : product.rating} (${product.ratingCount < 1 ? 0 : product.ratingCount})',
                        style: CommonText.fBodySmall
                            .copyWith(color: CommonColor.textGrey),
                      ),
                    ],
                  ),
                  Text(
                    CurrencyHelper.formatCurrencyDouble(product.price),
                    style: CommonText.fHeading3
                        .copyWith(color: CommonColor.primary),
                  ),
                ],
              ),
              const SizedBox(height: AppConstant.paddingNormal),
              Text(product.description,
                  style: CommonText.fBodyLarge
                      .copyWith(color: CommonColor.textGrey, height: 1.5)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BlocConsumer<ProductDetailCubit, ProductDetailState>(
          listener: (context, state) {
        if (state is SuccessAddTocart) {
          CommonSnacbar.showSuccessSnackbar(
              context: context, message: 'Added to cart');
        }
      }, builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstant.paddingNormal,
              vertical: AppConstant.paddingSmall),
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: CommonColor.borderButton, width: 0.3)),
            color: CommonColor.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonButtonOutlined(
                  onPressed: () {},
                  text: 'Edit Product',
                ),
              ),
              // CommonButtonOutlined(
              //   onPressed: state is LoadingAddTocart
              //       ? () {}
              //       : () {
              //           ProductDetailCartModel productCart =
              //               ProductDetailCartModel(
              //                   productId: product.id,
              //                   quantity: 1,
              //                   product: product);

              //           context.read<ProductDetailCubit>().addCart(CartModel(
              //               id: "", userId: "", productCart: [productCart]));
              //         },
              //   text: 'Add to Cart',
              //   isLoading: state is LoadingAddTocart,
              // ),
              const SizedBox(width: AppConstant.paddingSmall),
              Expanded(
                child: CommonButtonOutlined(
                  onPressed: () {},
                  text: 'Delete Product',
                  color: CommonColor.errorColor,
                  fontColor: CommonColor.errorColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
