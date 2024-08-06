import 'package:flutter/material.dart';

import '../../core/app_constant.dart';
import '../../core/common/common_color.dart';
import '../../core/common/common_text.dart';
import '../../core/common/enum/common_status_transaction.dart';

class ItemStatusTransactionWidget extends StatelessWidget {
  final CommonStatusTransaction status;
  const ItemStatusTransactionWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppConstant.paddingExtraSmall,
          horizontal: AppConstant.paddingNormal),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstant.radiusExtraLarge),
          color: (status == CommonStatusTransaction.success
                  ? CommonColor.successColor
                  : status == CommonStatusTransaction.failed
                      ? CommonColor.errorColor
                      : CommonColor.warningColor)
              .withOpacity(.1)),
      child: Text(
          status == CommonStatusTransaction.success
              ? 'Success'
              : status == CommonStatusTransaction.failed
                  ? 'Failed'
                  : 'Pending',
          style: CommonText.fBodySmall.copyWith(
              color: status == CommonStatusTransaction.success
                  ? CommonColor.successColor
                  : status == CommonStatusTransaction.failed
                      ? CommonColor.errorColor
                      : CommonColor.warningColor)),
    );
  }
}
