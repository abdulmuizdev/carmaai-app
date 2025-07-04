import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String value;

  const BalanceCard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2.8,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Balance',
              style: TextStyle(
                fontSize: 22,
                color: AppColors.white,
              ),
            ),
            Text(
              Utils.formatNumber(value) ?? '--',
              style: TextStyle(
                fontSize: 48,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
