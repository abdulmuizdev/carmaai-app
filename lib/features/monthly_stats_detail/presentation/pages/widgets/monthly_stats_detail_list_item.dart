import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:flutter/material.dart';

class MonthlyStatsDetailListItem extends StatelessWidget {
  final MonthWiseFinancialEntity entity;
  final bool isLast;

  const MonthlyStatsDetailListItem({
    super.key,
    required this.entity,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.year,
                style: TextStyle(
                  color: AppColors.secondary.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      entity.month,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      entity.totalExpenses,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      entity.totalIncome,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      entity.balance,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLast) ...[
          Container(
            height: 0.5,
            color: AppColors.primary.withOpacity(0.2),
          ),
        ]
      ],
    );
  }
}
