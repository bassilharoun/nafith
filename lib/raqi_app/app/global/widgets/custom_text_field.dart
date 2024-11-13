import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:nafith/raqi_app/app/global/styles/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.inputKey,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.canUnObsecure = false,
    this.isObsecure = false,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.borderRadius,
    this.isDense,
    this.fillColor,
    this.enabled = true,
    this.readOnly = false,
    this.showErrorOnUnfocused = false,
  });

  final Key? inputKey;
  final String? labelText;
  final String? hintText;
  final bool canUnObsecure;
  final void Function(String)? onChanged;
  final bool isObsecure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final double? borderRadius;
  final bool? isDense;
  final Color? fillColor;
  final bool enabled;
  final bool readOnly;
  final bool showErrorOnUnfocused;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscureText;
  String? _errorText;
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.isObsecure;

    focusNode = widget.focusNode ?? FocusNode();

    if (widget.showErrorOnUnfocused) {
      // Attach a listener to the focus node to run validation on unfocused
      focusNode?.addListener(() {
        if (!focusNode!.hasFocus) {
          setState(() {
            _errorText = widget.validator?.call(widget.controller?.text);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.showErrorOnUnfocused) {
      focusNode?.removeListener(() {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      key: widget.inputKey,
      validator: widget.validator,
      controller: widget.controller,
      focusNode: focusNode,
      onChanged: (value) {
        if (widget.showErrorOnUnfocused) {
          // Remove error and re-validate on text change
          setState(() {
            _errorText =
                widget.validator?.call(value); // Re-run the validator on change
          });
        }

        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      obscureText: isObscureText,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        errorText: _errorText,
        isDense: widget.isDense,
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        suffixIcon: widget.canUnObsecure
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                icon: Icon(
                  isObscureText ? Icons.visibility : Icons.visibility_off,
                  color: ColorNeutrals.grey1,
                ),
              )
            : widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        labelStyle: AppStyles.style16Medium(
          FontFamily.Cairo,
          context,
          color: ColorNeutrals.secondaryText,
        ).copyWith(fontWeight: FontWeight.bold),
        hintText: widget.hintText,
        hintStyle: AppStyles.style16Medium(
          FontFamily.Cairo,
          context,
          color: ColorNeutrals.secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.sp),
          borderSide: const BorderSide(color: ColorNeutrals.grey3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.sp),
          borderSide: const BorderSide(color: ColorNeutrals.grey3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.sp),
          borderSide: BorderSide(
            color: widget.readOnly ? ColorNeutrals.grey3 : ColorRaqi.purple100,
            width: widget.readOnly ? 1 : 2,
          ),
        ),
      ),
    );
  }
}
