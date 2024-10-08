import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIcon {
  static const _assetPath = "assets/icons";

  static SvgPicture getImageFromAsset(String fileName,
      {Color? color, double? width, double? height}) {
    if (width != null && height != null) {
      return SvgPicture.asset(
        "$_assetPath/$fileName",
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        width: width,
        height: height,
      );
    }

    return SvgPicture.asset(
      "$_assetPath/$fileName",
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  //EXAMPLE FOR GETTING SVG IMAGE
  ///Bottom menu icon
  static SvgPicture productActive = getImageFromAsset("product-active.svg");
  static SvgPicture productDefault = getImageFromAsset("product-default.svg");
  static SvgPicture cartActive = getImageFromAsset("cart-active.svg");
  static SvgPicture cartDefault = getImageFromAsset("cart-default.svg");
  static SvgPicture profileActive = getImageFromAsset("profile-active.svg");
  static SvgPicture profileDefault = getImageFromAsset("profile-default.svg");
  static SvgPicture transactionActive =
      getImageFromAsset("transaction-active.svg");
  static SvgPicture transactionDefault =
      getImageFromAsset("transaction-default.svg");
  static SvgPicture cashierActive = getImageFromAsset("cashier-active.svg");
  static SvgPicture cashierDefault = getImageFromAsset("cashier-default.svg");

  //cart menu icon
  static SvgPicture delete = getImageFromAsset("delete.svg");
  static SvgPicture minus = getImageFromAsset("minus.svg");
  static SvgPicture plus = getImageFromAsset("plus.svg");
  static SvgPicture filter =
      getImageFromAsset("filter.svg", width: 24, height: 24);

  //profile menu icon
  static SvgPicture address = getImageFromAsset("address.svg");
  static SvgPicture email = getImageFromAsset("email.svg");
  static SvgPicture phone = getImageFromAsset("phone.svg");
  static SvgPicture username = getImageFromAsset("username.svg");
}
