import 'package:flutter/material.dart';

import '../../app_constant.dart';
import '../common_color.dart';
import '../common_text.dart';

class CommonSnacbar {
  static void showErrorSnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: CommonText.fBodyLarge.copyWith(color: CommonColor.white)),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: CommonColor.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstant.paddingNormal),
        dismissDirection: DismissDirection.up,
      ),
    );
  }

  static void showSuccessSnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: CommonText.fBodyLarge.copyWith(color: CommonColor.white)),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: CommonColor.successColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstant.paddingNormal),
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}
