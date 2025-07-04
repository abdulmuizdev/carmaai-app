import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:flutter/material.dart';

class ItemCell extends StatelessWidget {
  final String imageAsset;
  final String label;
  final bool? isLast;
  final VoidCallback onPressed;

  const ItemCell({super.key, required this.imageAsset, required this.label, this.isLast, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 20,
                        child: Image.asset(imageAsset),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        label,
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.secondary.withOpacity(0.5),
                    size: 12,
                  ),
                ],
              ),
            ),
            if (!(isLast ?? false))
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.5,
                color: AppColors.primary.withOpacity(0.2),
              )
          ],
        ),
      ),
    );
  }
}
