import 'package:flutter/material.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';

enum Status { warning, danger }

class AlertProductWidget extends StatelessWidget {
  final String text;
  final Status status;

  const AlertProductWidget({
    super.key,
    required this.text,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.paddingNormal,
          vertical: AppConstant.paddingSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstant.radiusNormal),
        color: status == Status.warning
            ? CommonColor.warningColor.withOpacity(.1)
            : CommonColor.errorColor.withOpacity(.1),
        border: Border.all(
            color: status == Status.warning
                ? CommonColor.warningColor
                : CommonColor.errorColor),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: status == Status.warning
                  ? CommonColor.warningColor
                  : CommonColor.errorColor),
          const SizedBox(width: AppConstant.paddingMedium),
          Text(text,
              style: CommonText.fBodySmall.copyWith(
                  color: status == Status.warning
                      ? CommonColor.warningColor
                      : CommonColor.errorColor,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
