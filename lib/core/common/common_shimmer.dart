import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? hightlightColor;
  final bool enabled;
  final Widget? child;

  const CommonShimmer(
      {super.key,
      this.width,
      this.height,
      this.borderRadius,
      this.baseColor,
      this.hightlightColor,
      this.enabled = true,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade300,
        highlightColor: hightlightColor ?? Colors.grey.shade100,
        enabled: enabled,
        child: child ??
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius ?? BorderRadius.circular(12.0)),
            ));
  }
}
