import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final String imageAsset;
  final String imageAssetToggled;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavigationItem({
    super.key,
    required this.imageAsset,
    required this.imageAssetToggled,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label.isNotEmpty) ...[
              SizedBox(
                width: 30, height: 18,
                child: Image.asset(isSelected ? imageAssetToggled : imageAsset),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: isSelected ? AppColors.primary : AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
