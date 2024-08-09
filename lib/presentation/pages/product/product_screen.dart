import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_shimmer.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/widgets/common_text_input.dart';
import '../../cubit/product_cubit/product/product_cubit.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_widget.dart';
import 'widgets/category_list_widget.dart';
import 'widgets/single_product_list_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        backgroundColor: CommonColor.white,
        scrolledUnderElevation: 0.0,
        title: Text('Discover Products', style: CommonText.fHeading2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppConstant.paddingSmall),
            child: IconButton(
                onPressed: () => context.read<ProductCubit>().showNotif(),
                icon: const Icon(Icons.notifications_active_outlined)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.pushNamed(RoutesName.addProducts),
        backgroundColor: CommonColor.primary,
        extendedPadding: const EdgeInsets.all(AppConstant.paddingNormal),
        icon: const Icon(Icons.add, color: CommonColor.white),
        label: Text('Add Product',
            style: CommonText.fBodySmall.copyWith(color: CommonColor.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductCubit>().fetchAllProducts(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstant.paddingNormal),
              child: CommonTextInput(
                textEditingController: TextEditingController(),
                focusNode: FocusNode(),
                hintText: 'Search Products ...',
                textInputAction: TextInputAction.done,
                obsecureText: false,
                maxLines: 1,
                onFieldSubmit: (value) {},
                onChanged: (value) =>
                    context.read<ProductCubit>().searchProducts(value),
                textInputType: TextInputType.text,
              ),
            ),
            const SizedBox(height: AppConstant.paddingSmall),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppConstant.paddingNormal,
                  bottom: AppConstant.paddingNormal),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      return CategoryListWidget(
                        listCategories: state.categories,
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoaded) {
                    return showProductList(state);
                  }

                  if (state is ProductError) {
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Center(child: Text(state.message));
                        });
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstant.paddingNormal),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return CommonShimmer(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstant.paddingNormal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showProductList(ProductLoaded state) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(
          left: AppConstant.paddingNormal,
          right: AppConstant.paddingNormal,
          bottom: AppConstant.paddingNormal),
      itemCount: state.products.length > 1 ? state.products.length : 1,
      itemBuilder: (context, index) {
        if (state.products.isEmpty) {
          return const EmptyWidget(
            message: 'No Products Found',
            margin: EdgeInsets.zero,
          );
        }

        return InkWell(
          onTap: () => context.pushNamed(RoutesName.productsDetail,
              extra: state.products[index]),
          child: Container(
            padding: EdgeInsets.only(
                top: AppConstant.paddingNormal,
                bottom: index == state.products.length - 1
                    ? AppConstant.paddingLarge * 3
                    : AppConstant.paddingNormal),
            decoration: index == state.products.length - 1
                ? null
                : const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: CommonColor.borderColorDisable))),
            child: Column(
              children: [
                SingleProductListWidget(product: state.products[index]),
              ],
            ),
          ),
        );
      },
    );
  }
}
