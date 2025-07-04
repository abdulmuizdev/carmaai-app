import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OdometerButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;
  final bool? isAiPowered;

  const OdometerButton({
    super.key,
    required this.image,
    required this.label,
    required this.onPressed,
    this.isAiPowered,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.16),
                        offset: const Offset(0, 0),
                        blurRadius: 29,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset(image, width: 30, height: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isAiPowered ?? false) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.auto_awesome_sharp),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
