// ignore_for_file: prefer_if_null_operators

import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool disabled;
  final bool showLockIcon;
  final TextInputType? inputType;
  final String? Function(dynamic)? validator;
  final Function()? onTap;
  final List<TextInputFormatter>? formatter;
  final Function(String value)? onChange;
  final bool? readOnly;
  final bool showBorder;
  final bool showRightBorder;
  const CustomInputField(
      {super.key,
      required this.controller,
      this.showRightBorder = true,
      this.formatter,
      this.isPassword = false,
      this.disabled = false,
      this.showLockIcon = true,
      this.readOnly,
      this.onChange,
      this.showBorder = true,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      this.hintText,
      this.validator,
      this.inputType = TextInputType.text,
      this.decoration = const InputDecoration()});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool obscurePassword = true;

  void updatePassword() => setState(() => obscurePassword = !obscurePassword);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          onTap: widget.onTap,
          readOnly: widget.readOnly ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.isPassword ? obscurePassword : false,
          cursorColor:AppTheme.primaryColor,
          onChanged: widget.onChange,
          inputFormatters: widget.formatter,
          validator: widget.validator ??
              (string) {
                if (string.toString().isEmpty) {
                  return "${widget.hintText} cannot be empty";
                }
                return null;
              },
          decoration: widget.decoration.copyWith(
              hintStyle:AppTheme.bodyText
                  .copyWith(fontSize: 15, color: const Color(0xff8A8A8A)),
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal:15,vertical: 20),
              prefixIcon:  widget.prefixIcon,
                    
              suffixIcon: widget.isPassword || widget.suffixIcon != null
                  ? Container(
                      constraints: const BoxConstraints(maxWidth: 50),
                      margin: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              left: widget.isPassword || !widget.showRightBorder
                                  ? BorderSide.none
                                  : const BorderSide(
                                      width: 2, color: Color(0xffE6E6E6)))),
                      child: widget.suffixIcon == null
                          ? widget.isPassword
                              ? InkWell(
                                  onTap: () => updatePassword(),
                                  child: SvgPicture.asset(obscurePassword
                                      ? "assets/icons/closed-eyes.svg"
                                      : "assets/icons/eye.svg",
                                      colorFilter: const ColorFilter.mode(
                                             Colors.white,
                                        BlendMode.srcIn,
                                      )))
                              : null
                          : widget.suffixIcon,
                    )
                  : null,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 216, 55, 55))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 216, 55, 55))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xffE6E6E6))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xffE6E6E6))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xffE6E6E6)))),
          style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w700)
        )
      ;
  }
}
