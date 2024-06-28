import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool obsText;
  final TextEditingController controller;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final String? prefixTooltipMessage; // Added parameter for tooltip message
  final Widget? suffixIcon;
  //final Widget? onSuffixIconPressed;
  final TextStyle? textStyle;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixIconPressed;

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obsText,
    required this.controller,
    required this.margin,
    required this.padding,
    this.focusNode,
    this.prefixIcon,
    this.prefixTooltipMessage,
    this.suffixIcon,
    //this.onSuffixIconPressed,
    this.textStyle,
    this.fillColor,
    this.onChanged,
    this.onSuffixIconPressed,
    BoxDecoration? decoration,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        margin: widget.margin,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obsText && _isObscure,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.black),
            ),
            fillColor: widget.fillColor ?? Colors.transparent,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontStyle: widget.textStyle?.fontStyle,
              letterSpacing: widget.textStyle?.letterSpacing,
            ),
            prefixIcon: widget.prefixIcon != null
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message:
                          widget.prefixTooltipMessage ?? '', // Tooltip message
                      child: widget.prefixIcon!,
                    ),
                    onEnter: (_) {},
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            suffixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          style: widget.textStyle,
        ),
      ),
    );
  }
}
