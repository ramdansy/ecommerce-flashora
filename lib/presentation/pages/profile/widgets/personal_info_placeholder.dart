import 'package:flutter/material.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_shimmer.dart';

class PersonalInfoPlaceholder extends StatelessWidget {
  const PersonalInfoPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstant.paddingNormal),
      children: [
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 96),
        const SizedBox(height: AppConstant.paddingExtraLarge),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
        const SizedBox(height: AppConstant.paddingNormal),
        CommonShimmer(width: MediaQuery.of(context).size.width, height: 80),
      ],
    );
  }
}
