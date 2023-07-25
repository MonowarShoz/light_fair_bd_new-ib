import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';

import 'theme/custom_themes.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  final VoidCallback? onSuffixTap;
  final IconData? suffixIconUrl;
  final String? prefixIconUrl;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isResponsive;
  final double? width;
  final int? minLines;

  CustomTextField(
      {this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSuffixTap,
      this.fillColor,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.prefixIconUrl,
      this.isSearch = false,
      this.width,
      this.minLines,
      this.isResponsive = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width != null ? widget.width : null,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 2))
      ]),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: robotoRegular.copyWith(
            color: Colors.black87,
            fontSize: widget.isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: ColorResources.getPrimary(context),
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: false,
        minLines: widget.minLines != null ? widget.minLines : 1,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
              ]
            : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.isResponsive ? 18 : 16,
              horizontal: widget.isResponsive ? 24 : 22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                width: widget.isShowBorder ? 1 : 0,
                color: widget.isShowBorder ? Colors.green : Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57))),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor != null ? widget.fillColor : Colors.white,
          hintStyle: robotoRegular.copyWith(
              fontSize: widget.isResponsive ? 20 : Dimensions.FONT_SIZE_LARGE,
              color: Colors.grey),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_SMALL),
                  child: Image.asset(widget.prefixIconUrl!),
                )
              : SizedBox.shrink(),
          prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
                  ? IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: () => widget.onSuffixTap,
                          icon: Icon(widget.suffixIconUrl,
                              size: 25, color: Colors.black),
                        )
                      : null
              : null,
        ),

        onTap: widget.onTap,
        onSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit!(text),
        onChanged: widget.onChanged,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
