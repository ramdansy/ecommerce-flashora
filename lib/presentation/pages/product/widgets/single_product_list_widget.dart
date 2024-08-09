import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/enum/common_form_validate_type.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/common_snacbar.dart';
import '../../../../core/common/widgets/common_text_input.dart';
import '../../../../domain/entities/product_model.dart';
import '../../../cubit/product_cubit/crud_product/crud_product_cubit.dart';
import 'alert_product_widget.dart';

class SingleProductListWidget extends StatefulWidget {
  final ProductModel product;

  const SingleProductListWidget({super.key, required this.product});

  @override
  State<SingleProductListWidget> createState() =>
      _SingleProductListWidgetState();
}

class _SingleProductListWidgetState extends State<SingleProductListWidget> {
  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final stockFocus = FocusNode();
  final priceFocus = FocusNode();

  bool showUpdateStockCont = false;
  bool showUpdatePriceCont = false;

  @override
  void initState() {
    stockController.text = widget.product.stock.toString();
    priceController.text = CurrencyHelper.thousandFormatCurrency(
        widget.product.price.toStringAsFixed(0));
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
                    fit: BoxFit.cover),
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
                          if (widget.product.rating > 0)
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: CommonColor.warningColor),
                                const SizedBox(
                                    width: AppConstant.paddingExtraSmall),
                                Text(
                                  '${widget.product.rating} (${widget.product.ratingCount})  |  ',
                                  style: CommonText.fBodySmall
                                      .copyWith(color: CommonColor.textGrey),
                                ),
                              ],
                            ),
                          Text(widget.product.category.toUpperCase(),
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
        if (widget.product.stock <= 10 && widget.product.stock > 0) ...[
          const SizedBox(height: AppConstant.paddingSmall),
          const AlertProductWidget(
              text: 'Your stock is running low', status: Status.warning)
        ],
        if (widget.product.stock < 1) ...[
          const SizedBox(height: AppConstant.paddingSmall),
          const AlertProductWidget(
              text: 'Your stock is empty. Update it soon!',
              status: Status.danger)
        ],
        const SizedBox(height: AppConstant.paddingSmall),
        Row(
          children: [
            Expanded(
              child: CommonButtonOutlined(
                  onPressed: () {
                    stockController.text = widget.product.stock.toString();
                    setState(() {
                      showUpdateStockCont = !showUpdateStockCont;
                      showUpdatePriceCont = false;
                    });
                  },
                  text: 'Update Stock',
                  paddingVertical: 0,
                  color: CommonColor.primary),
            ),
            const SizedBox(width: AppConstant.paddingSmall),
            Expanded(
              child: CommonButtonOutlined(
                onPressed: () {
                  priceController.text = CurrencyHelper.thousandFormatCurrency(
                      widget.product.price.toStringAsFixed(0));
                  setState(() {
                    showUpdatePriceCont = !showUpdatePriceCont;
                    showUpdateStockCont = false;
                  });
                },
                text: 'Update Price',
                paddingVertical: 0,
                color: CommonColor.primary,
              ),
            ),
            const SizedBox(width: AppConstant.paddingExtraSmall),
            BlocConsumer<CrudProductCubit, CrudProductState>(
              listener: (context, state) {
                if (state is DeleteProductError) {
                  CommonSnacbar.showErrorSnackbar(
                      context: context, message: state.message);
                }
              },
              builder: (context, state) {
                return CommonButtonIcon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: CommonColor.white,
                        title:
                            Text('Delete Product', style: CommonText.fHeading5),
                        content: Text(
                            'Are you sure want to delete this product?Product which already deleted can not be recovered.',
                            style: CommonText.fBodyLarge),
                        actions: [
                          Row(children: [
                            Expanded(
                                child: CommonButtonOutlined(
                                    onPressed: () => Navigator.pop(context),
                                    text: 'No, Cancel')),
                            const SizedBox(width: AppConstant.paddingSmall),
                            Expanded(
                                child: CommonButtonFilled(
                              onPressed: () {
                                context
                                    .read<CrudProductCubit>()
                                    .deleteProduct(context, widget.product.id);
                              },
                              text: 'Yes, Delete',
                              isLoading: state is DeletingProduct,
                            )),
                          ])
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete, color: CommonColor.errorColor),
                  borderColor: CommonColor.errorColor,
                );
              },
            ),
          ],
        ),
        if (showUpdateStockCont) ...[
          updateStockContainer(widget.product),
        ],
        if (showUpdatePriceCont) ...[
          updatePriceContainer(widget.product),
        ],
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

        if (state is UpdateStockError) {
          CommonSnacbar.showErrorSnackbar(
              context: context, message: state.message);
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
                          onPressed: () {
                            if (int.parse(stockController.text) > 0) {
                              stockController.text =
                                  (int.parse(stockController.text) - 1)
                                      .toString();
                            }
                          },
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

  Widget updatePriceContainer(ProductModel product) {
    return BlocConsumer<CrudProductCubit, CrudProductState>(
      listener: (context, state) {
        if (state is UpdatedPrice) {
          CommonSnacbar.showSuccessSnackbar(
              context: context, message: 'Price Updated');
          setState(() => showUpdatePriceCont = !showUpdatePriceCont);
        }

        if (state is UpdatePriceError) {
          CommonSnacbar.showErrorSnackbar(
              context: context, message: state.message);
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
                  Text('Update Price',
                      style: CommonText.fBodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () => setState(
                          () => showUpdatePriceCont = !showUpdatePriceCont),
                      child:
                          const Icon(Icons.close, color: CommonColor.primary)),
                ],
              ),
              const SizedBox(height: AppConstant.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: CommonTextInput(
                      textEditingController: priceController,
                      focusNode: priceFocus,
                      hintText: '0',
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      prefix: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstant.paddingNormal),
                          child: Text('Rp.', style: CommonText.fHeading5)),
                      textInputAction: TextInputAction.done,
                      onFieldSubmit: (_) {},
                      textInputType: TextInputType.number,
                      textStyle: CommonText.fHeading5,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(
                            thousandSeparator: ThousandSeparator.Period,
                            mantissaLength: 0)
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingSmall),
                  CommonButtonFilled(
                    onPressed: () {
                      context.read<CrudProductCubit>().updatePriceProduct(
                          context,
                          widget.product.id,
                          double.parse(CurrencyHelper.reformatCurrencyToString(
                              priceController.text)));
                    },
                    text: 'Update',
                    paddingVertical: AppConstant.paddingNormal,
                    isLoading: state is UpdatingPrice,
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
