import 'package:flutter/material.dart';

import '../../core/app_constant.dart';
import '../../core/common/common_text.dart';

class SingleLabelValueWidget extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? valueWidget;
  const SingleLabelValueWidget({
    super.key,
    required this.title,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstant.paddingSmall),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: CommonText.fBodyLarge),
          ),
          const SizedBox(width: AppConstant.paddingSmall),
          valueWidget ?? Text(value ?? "", style: CommonText.fHeading5),
        ],
      ),
    );
  }
}
