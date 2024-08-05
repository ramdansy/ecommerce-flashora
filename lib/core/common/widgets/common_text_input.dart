import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_constant.dart';
import '../common_color.dart';
import '../common_text.dart';
import '../enum/common_form_validate_type.dart';

class CommonTextInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String hintText;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmit;
  final bool obsecureText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool enabled;
  final TextInputType textInputType;
  final Widget? prefix;
  final Widget? prefixIcon;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final String? label;
  final String? helper;
  final List<CommonFormValidateType> validators;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  final double? inputPaddingHorizontal;
  final TextCapitalization textCapitalization;
  final bool autoFocus;
  final String? errorText;
  final String? Function(String?)? customValidator;

  const CommonTextInput({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.hintText,
    required this.textInputAction,
    required this.onFieldSubmit,
    this.obsecureText = false,
    this.suffix,
    this.suffixIcon,
    this.enabled = true,
    required this.textInputType,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.maxLines,
    this.contentPadding = const EdgeInsets.symmetric(
        vertical: AppConstant.paddingNormal, horizontal: 0),
    this.onChanged,
    this.inputFormatters,
    this.validator,
    this.prefixIcon,
    this.label,
    this.helper,
    this.validators = const <CommonFormValidateType>[],
    this.constraints,
    this.textStyle,
    this.inputPaddingHorizontal = AppConstant.paddingNormal,
    this.textCapitalization = TextCapitalization.sentences,
    this.autoFocus = false,
    this.errorText,
    this.customValidator,
  });

  @override
  State<CommonTextInput> createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  Color _borderColor = CommonColor.borderButton;
  bool obscurePass = true;

  @override
  void initState() {
    widget.textEditingController.addListener(() {
      if (mounted) {
        setState(() {
          _borderColor = widget.textEditingController.text.isNotEmpty
              ? CommonColor.primary
              : CommonColor.borderButton;
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((widget.label ?? "").isNotEmpty) ...[
          Text(
            widget.label!,
            style: CommonText.fBodySmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppConstant.paddingSmall),
        ],
        TextFormField(
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          controller: widget.textEditingController,
          focusNode: widget.focusNode,
          cursorColor: CommonColor.primary,
          obscureText: widget.obsecureText ? obscurePass : widget.obsecureText,
          autofocus: widget.autoFocus,
          enabled: widget.enabled,
          keyboardType: widget.textInputType,
          textCapitalization: widget.textCapitalization,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: widget.textStyle ?? CommonText.fBodyLarge,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            hintText: widget.hintText,
            constraints: widget.constraints,
            hintStyle: widget.textStyle
                    ?.copyWith(color: CommonColor.borderButton) ??
                CommonText.fBodyLarge.copyWith(color: CommonColor.borderButton),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstant.radiusNormal)),
                borderSide: BorderSide(color: _borderColor)),
            disabledBorder: const OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstant.radiusNormal)),
                borderSide: BorderSide(color: CommonColor.borderColorDisable)),
            focusedBorder: const OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstant.radiusNormal)),
                borderSide: BorderSide(color: CommonColor.primary)),
            errorText: widget.errorText,
            errorBorder: const OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstant.radiusNormal)),
                borderSide: BorderSide(color: CommonColor.errorColor)),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstant.radiusNormal)),
                borderSide: BorderSide(color: CommonColor.errorColor)),
            errorStyle:
                CommonText.fBodySmall.copyWith(color: CommonColor.errorColor),
            errorMaxLines: 2,
            suffixIcon: !widget.obsecureText
                ? widget.suffixIcon
                : IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePass = !obscurePass;
                      });
                    },
                    icon: Icon(obscurePass
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded),
                    color: CommonColor.borderButton,
                  ),
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix ??
                (widget.prefixIcon != null
                    ? null
                    : SizedBox(width: widget.inputPaddingHorizontal)),
            suffix: widget.suffix ??
                (widget.prefixIcon != null
                    ? null
                    : SizedBox(width: widget.inputPaddingHorizontal)),
            prefixStyle: const TextStyle(
              color: CommonColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmit,
          onChanged: widget.onChanged,
          validator: widget.customValidator ?? _handleValidator,
        ),
        if ((widget.helper ?? "").isNotEmpty) ...[
          const SizedBox(height: AppConstant.paddingExtraSmall),
          Text(
            widget.helper!,
            style: CommonText.fBodySmall.copyWith(
                fontWeight: FontWeight.w400, color: CommonColor.hintTextColor),
          ),
        ]
      ],
    );
  }

  String? _handleValidator(String? value) {
    var isRequired = widget.validators.contains(
      CommonFormValidateType.noEmpty,
    );
    var validateEmail = widget.validators.contains(
      CommonFormValidateType.email,
    );
    var validateAlphanumeric = widget.validators
        .contains(CommonFormValidateType.alphanumericWithSpecial);

    if (isRequired && (value == null || value.isEmpty)) {
      return AppConstant.textErrorEmpty
          .replaceAll('@fieldName', widget.hintText);
    }
    if (validateEmail && !(value?.isValidEmail()).safe()) {
      return AppConstant.textInvalidEmailFormat;
    }
    if (validateAlphanumeric && !(value?.isAlphanumeric()).safe()) {
      return 'alphanumeric only';
    }

    return null;
  }
}

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool isAlphanumeric() {
    return RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(this);
  }
}

extension NullableBoolean on bool? {
  bool safe() {
    return this ?? false;
  }
}
