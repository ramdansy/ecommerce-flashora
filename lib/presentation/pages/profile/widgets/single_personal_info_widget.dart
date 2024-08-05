import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';

class SinglePersonalInfoWidget extends StatelessWidget {
  final String label;
  final String value;
  final SvgPicture icon;

  const SinglePersonalInfoWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: AppConstant.paddingNormal),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: CommonColor.borderButton)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: CommonText.fBodySmall
                        .copyWith(color: CommonColor.textGrey)),
                const SizedBox(height: AppConstant.paddingExtraSmall),
                Text(
                  value,
                  style: CommonText.fHeading5,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstant.paddingSmall),
              ],
            ),
          ),
        )
      ],
    );
  }
}
