import 'package:flutter/material.dart';

import '../common_color.dart';

class Line extends StatelessWidget {
  const Line({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: .5,
      color: CommonColor.borderColorDisable,
    );
  }
}
