import 'package:flutter/material.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_shimmer.dart';

class ProductCashierPlaceholder extends StatelessWidget {
  const ProductCashierPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
          left: AppConstant.paddingNormal,
          right: AppConstant.paddingNormal,
          bottom: AppConstant.paddingNormal),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppConstant.paddingNormal,
          mainAxisSpacing: AppConstant.paddingNormal,
          childAspectRatio: 9 / 17),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Column(
          children: [
            CommonShimmer(height: 180),
            SizedBox(height: AppConstant.paddingNormal),
            CommonShimmer(height: 20),
            SizedBox(height: AppConstant.paddingNormal),
            CommonShimmer(height: 20),
            SizedBox(height: AppConstant.paddingNormal),
            CommonShimmer(height: 40),
          ],
        );
      },
    );
  }
}
