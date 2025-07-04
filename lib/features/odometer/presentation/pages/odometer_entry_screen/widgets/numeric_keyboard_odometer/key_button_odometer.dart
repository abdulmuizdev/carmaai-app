import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class KeyButtonOdometer extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Function() onPressed;

  const KeyButtonOdometer(
      {super.key, this.text, this.child, this.backgroundColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color:
      (backgroundColor != null) ? backgroundColor : AppColors.secondary,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Stack(
            children: [
              if (text != null) ...[
                Text(
                  text!,
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
              ] else
                if (child != null) ...[
                  child!,
                ]
            ],
          ),
        ),
      ),
    );
  }
}
