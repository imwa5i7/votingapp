// ignore_for_file: prefer_const_constructors

import 'package:disney_voting/config/config.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final TextInputType keyboard;
  final FocusNode? focusNode;
  final VoidCallback? onFinished;
  final bool isPassword;
  final double horizontalPadding;
  final Function(String)? onValueChanged;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final bool expands;
  final int? maxLines;

  const CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.keyboard = TextInputType.text,
      this.focusNode,
      this.onFinished,
      this.isPassword = false,
      this.horizontalPadding = 20.0,
      this.onValueChanged,
      this.validator,
      this.label,
      this.expands = false,
      this.maxLines = 1,
      this.suffix})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomTextFormFieldState();
  }
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: TextFormField(
        onChanged: widget.onValueChanged,
        validator: widget.validator,
        textAlignVertical: TextAlignVertical.top,
        maxLines: widget.maxLines,
        expands: widget.expands,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: Sizes.s14),
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboard,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            suffixIcon: widget.suffix,
            suffixIconConstraints:
                BoxConstraints.tight(Size(Sizes.s40, Sizes.s40)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: Sizes.s12, vertical: Sizes.s8),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            errorBorder: OutlineInputBorder(),
            focusedErrorBorder: OutlineInputBorder(),
            errorMaxLines: 3,
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300)),
      ),
    );
  }
}
