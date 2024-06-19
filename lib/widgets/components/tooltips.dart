import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';

class CustomToolTip extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;

  const CustomToolTip({
    Key? key,
    required this.message,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: IconButton(
        icon: Icon(
          Icons.info_outlined,
          color: LightColors.textColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
