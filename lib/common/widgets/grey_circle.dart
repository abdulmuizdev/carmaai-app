import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GreyCircle extends StatelessWidget {
  final bool isSelected;
  final String? imageAsset;
  const GreyCircle({super.key, required this.isSelected, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: (isSelected) ? AppColors.primary.withOpacity(0.2) : const Color(0xFFE8E8EA),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          if (imageAsset != null) ...[
            Center(child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(imageAsset!),
            )),
          ]
        ],
      ),
    );
  }
}
