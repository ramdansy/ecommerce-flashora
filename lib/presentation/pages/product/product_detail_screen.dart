import 'package:finalproject_flashora/presentation/cubit/product_cubit/crud_product/crud_product_cubit.dart';
import 'package:finalproject_flashora/presentation/pages/product/widgets/alert_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_shimmer.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/utils/currency_helper.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../domain/entities/product_model.dart';
import '../../cubit/product_cubit/product_detail/product_detail_cubit.dart';
import '../../routes/app_routes.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailCubit>().getProduct(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        backgroundColor: CommonColor.white,
        scrolledUnderElevation: 0.0,
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
      body: SafeArea(
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return productPlaceholder();
            }

            if (state is ProductDetailLoaded) {
              return detailProduct(state);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget detailProduct(ProductDetailLoaded state) {
    final _product = state.product;
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.network(_product.image.first, fit: BoxFit.cover),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstant.paddingNormal),
                children: [
                  if (widget.product.stock <= 10 &&
                      widget.product.stock > 0) ...[
                    const AlertProductWidget(
                        text: 'Your stock is running low. Update it soon!',
                        status: Status.warning),
                    const SizedBox(height: AppConstant.paddingSmall),
                  ],
                  if (widget.product.stock < 1) ...[
                    const AlertProductWidget(
                        text: 'Your stock is empty. Update it soon!',
                        status: Status.danger),
                    const SizedBox(height: AppConstant.paddingSmall),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputChip(
                        label: Text(_product.category.toUpperCase(),
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
                                text: ' ${_product.stock}',
                                style: CommonText.fHeading5),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: AppConstant.paddingSmall),
                  Text(
                    _product.title,
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
                            '${_product.rating < 1 ? 0 : _product.rating} (${_product.ratingCount < 1 ? 0 : _product.ratingCount})',
                            style: CommonText.fBodySmall
                                .copyWith(color: CommonColor.textGrey),
                          ),
                        ],
                      ),
                      Text(
                        CurrencyHelper.formatCurrencyDouble(_product.price),
                        style: CommonText.fHeading3
                            .copyWith(color: CommonColor.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstant.paddingNormal),
                  Text(_product.description,
                      style: CommonText.fBodyLarge
                          .copyWith(color: CommonColor.textGrey, height: 1.5)),
                ],
              ),
            ],
          ),
        ),
        Container(
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
                  onPressed: () => context.pushNamed(RoutesName.addProducts,
                      extra: _product),
                  text: 'Edit Product',
                ),
              ),
              const SizedBox(width: AppConstant.paddingSmall),
              Expanded(
                child: CommonButtonOutlined(
                  onPressed: () => context
                      .read<CrudProductCubit>()
                      .deleteProduct(context, _product.id),
                  text: 'Delete Product',
                  color: CommonColor.errorColor,
                  fontColor: CommonColor.errorColor,
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
            ],
          ),
        )
      ],
    );
  }

  Widget productPlaceholder() {
    return ListView(
      children: [
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(
          width: MediaQuery.of(context).size.width,
          height: 40,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }
}
