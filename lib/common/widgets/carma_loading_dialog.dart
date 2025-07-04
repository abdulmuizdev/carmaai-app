import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CarmaLoadingDialog extends StatelessWidget {
  final bool? disableFullScreen;

  const CarmaLoadingDialog({super.key, this.disableFullScreen});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if ((disableFullScreen ?? false) == false) ...[
          Positioned.fill(
            child: Container(
              color: AppColors.secondary.withOpacity(0.5),
            ),
          ),
        ],
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                // TODO: correct this radius
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
