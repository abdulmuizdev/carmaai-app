import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/monthly_stats_detail/presentation/pages/monthly_stats_detail_screen.dart';
import 'package:flutter/material.dart';

class LifeTimeFinancialWidget extends StatelessWidget {
  final List<LifetimeFinancialsEntity> list;
  final List<MonthWiseFinancialEntity> list2;
  final MonthWiseFinancialsBloc monthWiseFinancialsBloc;

  const LifeTimeFinancialWidget(
      {super.key, required this.list, required this.list2, required this.monthWiseFinancialsBloc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.playSound('sounds/in.wav');
        Navigator.of(context).push(Utils.createRoute(MonthlyStatsDetailScreen(
            list: list2, monthWiseFinancialsBloc: monthWiseFinancialsBloc)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Time Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.secondary,
                        size: 15,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Text(
                    //   list.isEmpty ? '--' : list[0].month,
                    //   style: TextStyle(
                    //     color: AppColors.secondary,
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    Column(
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(
                            color: AppColors.red.withOpacity(1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          list.isEmpty ? '--' : list[0].lifeTimeExpenses,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                            color: AppColors.green.withOpacity(1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          list.isEmpty ? '--' : list[0].lifeTimeIncome,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(
                            color: AppColors.secondary.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          list.isEmpty ? '--' : list[0].lifeTimeBalance,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
