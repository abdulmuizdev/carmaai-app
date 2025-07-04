import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatefulWidget {
  final String label;
  final String imageAsset;
  final Widget? trailing;
  final VoidCallback onPressed;

  const SettingsItem({
    super.key,
    required this.label,
    required this.imageAsset,
    this.trailing,
    required this.onPressed,
  });

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset(widget.imageAsset),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            widget.trailing ?? Icon(Icons.arrow_forward_ios_outlined, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
