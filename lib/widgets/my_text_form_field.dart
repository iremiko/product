import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  final FormFieldValidator<String> validator;

  final String labelText;

  final int maxLines;

  final AutovalidateMode autoValidateMode;

  final bool obscureText;

  final TextInputType keyboardType;

  final EdgeInsets margin;

  final TextEditingController controller;

  final String initialValue;

  final Widget prefixIcon;

  final Widget suffixIcon;

  final List<TextInputFormatter> inputFormatter;

  final TextInputAction textInputAction;

  final ValueChanged<String> onFieldSubmitted;

  final FocusNode focusNode;

  const MyTextFormField(
      {Key key,
        this.onSaved,
        this.validator,
        this.labelText,
        this.maxLines = 1,
        this.autoValidateMode = AutovalidateMode.disabled,
        this.obscureText = false,
        this.keyboardType,
        this.margin = EdgeInsets.zero,
        this.controller,
        this.initialValue,
        this.prefixIcon,
        this.textInputAction,
        this.onFieldSubmitted,
        this.focusNode,
        this.suffixIcon, this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextFormField(
        autovalidateMode: autoValidateMode,

        initialValue: initialValue,
        controller: controller,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Theme.of(context).unselectedWidgetColor)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .unselectedWidgetColor
                      .withOpacity(0.3))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor)),
        ),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
      ),
    );
  }
}
