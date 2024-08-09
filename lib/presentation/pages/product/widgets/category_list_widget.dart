import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../cubit/cashier/cashier_cubit.dart';
import '../../../cubit/product_cubit/product/product_cubit.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({
    super.key,
    required this.listCategories,
    this.isCashier = false,
  });

  final List<Category> listCategories;
  final bool isCashier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        listCategories.length,
        (index) => Container(
          margin: const EdgeInsets.only(right: AppConstant.paddingSmall),
          child: InputChip(
            onPressed: () => isCashier
                ? context
                    .read<CashierCubit>()
                    .filterProducts(listCategories[index])
                : context
                    .read<ProductCubit>()
                    .filterProducts(listCategories[index]),
            label: Text(listCategories[index].name.toUpperCase(),
                style: CommonText.fBodySmall.copyWith(
                    color: listCategories[index].selected
                        ? CommonColor.white
                        : CommonColor.textGrey)),
            backgroundColor: listCategories[index].selected
                ? CommonColor.primary
                : CommonColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstant.radiusNormal),
              side: BorderSide(
                  color: listCategories[index].selected
                      ? CommonColor.primary
                      : CommonColor.borderColorDisable),
            ),
          ),
        ),
      ),
    );
  }
}
