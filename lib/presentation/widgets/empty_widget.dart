import 'package:flutter/material.dart';

import '../../core/app_constant.dart';
import '../../core/common/common_color.dart';
import '../../core/common/common_text.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? margin;
  const EmptyWidget({
    super.key,
    required this.message,
    this.margin = const EdgeInsets.all(AppConstant.paddingNormal),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstant.paddingNormal),
      margin: margin,
      decoration: BoxDecoration(
        color: CommonColor.borderColorDisable,
        borderRadius: BorderRadius.circular(AppConstant.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: CommonText.fBodyLarge),
        ],
      ),
    );
  }
}
