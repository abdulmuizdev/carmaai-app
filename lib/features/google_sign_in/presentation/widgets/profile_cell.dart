import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:flutter/material.dart';

class ProfileCell extends StatelessWidget {
  final String label;
  final String value;
  final bool? isLast;
  const ProfileCell(
      {super.key, required this.label, required this.value, this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$label: ',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
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
    );
  }
}
