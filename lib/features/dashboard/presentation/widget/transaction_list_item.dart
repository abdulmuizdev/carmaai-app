import 'package:carma/common/widgets/grey_circle.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final bool isExpense;
  final String title;
  final String date;
  final String time;
  final String value;
  final String? imageAsset;
  final bool showDate;
  final bool? isGrey;
  final String? totalDailyIncome;
  final String? totalDailyExpenses;

  const TransactionListItem({
    super.key,
    required this.isExpense,
    required this.title,
    required this.date,
    required this.time,
    required this.value,
    this.imageAsset,
    required this.showDate,
    this.isGrey,
    this.totalDailyIncome,
    this.totalDailyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDate) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.secondary.withOpacity(0.5),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Expenses: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      Utils.formatNumber(totalDailyExpenses ?? '0') ?? '--',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondary.withOpacity(1),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Income: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      Utils.formatNumber(totalDailyIncome ?? '0') ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondary.withOpacity(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.16),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                )
              ],
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 10,
                      height: 75,
                      decoration: BoxDecoration(
                        color: (isGrey ?? false) ? Colors.grey : ((isExpense) ? AppColors.red : AppColors.green),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 37,
                                      height: 37,
                                      child: GreyCircle(isSelected: true, imageAsset: imageAsset),
                                    ),
                                    SizedBox(width: 9),
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  (isGrey ?? false)
                                      ? '--'
                                      : ((isExpense)
                                          ? '- ${Utils.formatNumber(value) ?? '  -'}'
                                          : '+ ${Utils.formatNumber(value) ?? '  -'}'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: (isExpense) ? AppColors.red : AppColors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6, right: 18),
                    child: Text(
                      // time,
                      '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
