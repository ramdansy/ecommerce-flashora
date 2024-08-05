import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';

class QrisMethod extends StatelessWidget {
  const QrisMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Scan Qris',
            style: CommonText.fBodyLarge.copyWith(color: CommonColor.textGrey)),
        const SizedBox(height: AppConstant.paddingExtraLarge),
        Center(
          child: QrImageView(
            data: 'Qris Methos',
            version: QrVersions.auto,
            size: MediaQuery.of(context).size.width * .75,
            gapless: false,
          ),
        ),
      ],
    );
  }
}
