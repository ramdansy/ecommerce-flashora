import 'package:flutter/material.dart';

import '../../app_constant.dart';
import '../common_color.dart';

class CommonButtonFilled extends StatelessWidget {
  const CommonButtonFilled({
    super.key,
    required this.onPressed,
    required this.text,
    this.isEnable = true,
    this.fontWeight = FontWeight.w600,
    this.fontSize = AppConstant.paddingNormal,
    this.paddingVertical = AppConstant.paddingMedium,
    this.paddingHorizontal = AppConstant.paddingNormal,
    this.color = CommonColor.primary,
    this.fontColor = CommonColor.white,
    this.iconLeft,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isEnable;
  final FontWeight fontWeight;
  final double fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color color;
  final Color fontColor;
  final Widget? iconLeft;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: isEnable ? color : CommonColor.disabled,
        padding: EdgeInsets.symmetric(
            vertical: paddingVertical, horizontal: paddingHorizontal),
      ),
      child: isLoading
          ? const SizedBox(
              width: AppConstant.iconNormal,
              height: AppConstant.iconNormal,
              child: CircularProgressIndicator(color: CommonColor.white),
            )
          : iconLeft != null
              ? Row(
                  children: [
                    Container(child: iconLeft),
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fontColor,
                            fontWeight: fontWeight,
                            fontSize: fontSize),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: TextStyle(
                      color: fontColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize),
                ),
    );
  }
}

class CommonButtonOutlined extends StatelessWidget {
  const CommonButtonOutlined(
      {super.key,
      required this.onPressed,
      this.text,
      this.isEnable = true,
      this.fontWeight = FontWeight.w600,
      this.fontSize = AppConstant.paddingNormal,
      this.paddingVertical = AppConstant.paddingMedium,
      this.paddingHorizontal = AppConstant.paddingNormal,
      this.color = CommonColor.primary,
      this.fontColor = CommonColor.primary,
      this.child,
      this.borderRadius,
      this.padding,
      this.isLoading = false,
      this.iconLeft});

  final VoidCallback onPressed;
  final String? text;
  final bool isEnable;
  final FontWeight fontWeight;
  final double fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color color;
  final Color fontColor;
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool isLoading;
  final Widget? iconLeft;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnable ? onPressed : null,
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppConstant.radiusNormal),
          ),
          side: BorderSide(color: isEnable ? color : CommonColor.disabled),
          padding: padding ??
              EdgeInsets.symmetric(
                  vertical: paddingVertical, horizontal: paddingHorizontal)),
      child: isLoading
          ? const SizedBox(
              width: AppConstant.iconNormal,
              height: AppConstant.iconNormal,
              child: CircularProgressIndicator(color: CommonColor.primary),
            )
          : iconLeft != null
              ? Row(
                  children: [
                    Container(child: iconLeft),
                    Expanded(
                      child: Text(
                        text ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fontColor,
                            fontWeight: fontWeight,
                            fontSize: fontSize),
                      ),
                    ),
                  ],
                )
              : Text(
                  text ?? "",
                  style: TextStyle(
                      color: fontColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize),
                ),
    );
  }
}

class CommonButtonIcon extends StatelessWidget {
  const CommonButtonIcon(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.borderColor = CommonColor.white,
      this.backgroundColor = Colors.transparent,
      this.padding = const EdgeInsets.all(AppConstant.paddingSmall),
      this.borderRadius,
      this.constraints = const BoxConstraints()});

  final VoidCallback onPressed;
  final Widget icon;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: icon,
      padding: padding,
      constraints: constraints,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.circular(AppConstant.radiusNormal)),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
