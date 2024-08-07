import '../../../../core/common/widgets/common_snacbar.dart';
import '../../../cubit/product_cubit/crud_product/crud_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/enum/common_form_validate_type.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/common_text_input.dart';
import '../../../../domain/entities/product_model.dart';

class SingleProductListWidget extends StatefulWidget {
  final ProductModel product;

  const SingleProductListWidget({super.key, required this.product});

  @override
  State<SingleProductListWidget> createState() =>
      _SingleProductListWidgetState();
}

class _SingleProductListWidgetState extends State<SingleProductListWidget> {
  final stockController = TextEditingController();
  final stockFocus = FocusNode();

  bool showUpdateStockCont = false;
  bool showUpdatePriceCont = false;

  @override
  void initState() {
    stockController.text = widget.product.stock.toString();
    super.initState();
  }

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
                child: Image.network(widget.product.image.first,
                    fit: BoxFit.contain),
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
                        widget.product.title,
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
                                '${widget.product.rating} (${widget.product.ratingCount})',
                                style: CommonText.fBodySmall
                                    .copyWith(color: CommonColor.textGrey),
                              ),
                            ],
                          ),
                          Text('  |  ${widget.product.category.toUpperCase()}',
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
                                text: ' ${widget.product.stock}',
                                style: CommonText.fBodyLarge
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstant.paddingNormal),
                      Text(
                        CurrencyHelper.formatCurrencyDouble(
                            widget.product.price),
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
        if (widget.product.stock <= 10) ...[
          const SizedBox(height: AppConstant.paddingSmall),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstant.paddingNormal,
                vertical: AppConstant.paddingSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstant.radiusNormal),
              color: CommonColor.warningColor.withOpacity(.1),
              border: Border.all(color: CommonColor.warningColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: CommonColor.warningColor),
                const SizedBox(width: AppConstant.paddingMedium),
                Text('Your stock is running low. Update it soon!',
                    style: CommonText.fBodySmall.copyWith(
                        color: CommonColor.warningColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
        const SizedBox(height: AppConstant.paddingSmall),
        Row(
          children: [
            Expanded(
              child: CommonButtonOutlined(
                  onPressed: () {
                    setState(() {
                      showUpdateStockCont = !showUpdateStockCont;
                      showUpdatePriceCont = false;
                    });
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   builder: (BuildContext context) {
                    //     return BottomSheetEditStock(product: product);
                    //   },
                    // );
                  },
                  text: 'Update Stock',
                  paddingVertical: 0,
                  color: CommonColor.primary),
            ),
            const SizedBox(width: AppConstant.paddingSmall),
            Expanded(
              child: CommonButtonOutlined(
                  onPressed: () {
                    setState(() {
                      showUpdatePriceCont = !showUpdatePriceCont;
                      showUpdateStockCont = false;
                    });
                  },
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
        ),
        if (showUpdateStockCont) ...[
          updateStockContainer(widget.product),
        ],
        // if (showUpdatePriceCont) ...[
        //   updatePriceContainer(widget.product),
        // ],
      ],
    );
  }

  Widget updateStockContainer(ProductModel product) {
    return BlocConsumer<CrudProductCubit, CrudProductState>(
      listener: (context, state) {
        if (state is UpdatedStock) {
          CommonSnacbar.showSuccessSnackbar(
              context: context, message: 'Stock Updated');
          setState(() => showUpdateStockCont = !showUpdateStockCont);
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: AppConstant.paddingSmall),
          padding: const EdgeInsets.all(AppConstant.paddingMedium),
          decoration: BoxDecoration(
              color: CommonColor.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(AppConstant.radiusLarge)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Update Stock',
                      style: CommonText.fBodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () => setState(
                          () => showUpdateStockCont = !showUpdateStockCont),
                      child:
                          const Icon(Icons.close, color: CommonColor.primary)),
                ],
              ),
              const SizedBox(height: AppConstant.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: CommonTextInput(
                      textEditingController: stockController,
                      focusNode: stockFocus,
                      hintText: 'Stock',
                      textInputAction: TextInputAction.done,
                      obsecureText: false,
                      maxLines: 1,
                      onFieldSubmit: (value) {},
                      textInputType: TextInputType.number,
                      prefixIcon: IconButton(
                          onPressed: () => stockController.text =
                              (int.parse(stockController.text) - 1).toString(),
                          icon: const Icon(Icons.remove)),
                      suffixIcon: IconButton(
                          onPressed: () => stockController.text =
                              (int.parse(stockController.text) + 1).toString(),
                          icon: const Icon(Icons.add)),
                      textAlign: TextAlign.center,
                      validators: const [
                        CommonFormValidateType.noEmpty,
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingSmall),
                  CommonButtonFilled(
                    onPressed: () => context
                        .read<CrudProductCubit>()
                        .updateStockProduct(context, widget.product.id,
                            int.parse(stockController.text)),
                    text: 'Update',
                    paddingVertical: AppConstant.paddingNormal,
                    isLoading: state is UpdatingStock,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
