import 'package:carma/common/widgets/carma_app_bar.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_event.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_state.dart';
import 'package:carma/features/monthly_stats_detail/presentation/pages/widgets/monthly_stats_detail_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyStatsDetailScreen extends StatefulWidget {
  final List<MonthWiseFinancialEntity> list;
  final MonthWiseFinancialsBloc monthWiseFinancialsBloc;

  const MonthlyStatsDetailScreen({
    super.key,
    required this.list,
    required this.monthWiseFinancialsBloc,
  });

  @override
  State<MonthlyStatsDetailScreen> createState() => _MonthlyStatsDetailScreenState();
}

class _MonthlyStatsDetailScreenState extends State<MonthlyStatsDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.monthWiseFinancialsBloc.add(const FetchLifeTimeFinancials());
  }

  String _lifeTimeExpenses = '--';
  String _lifeTimeIncome = '--';
  String _lifeTimeBalance = '--';

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonthWiseFinancialsBloc, MonthWiseFinancialsState>(
      bloc: widget.monthWiseFinancialsBloc,
      listener: (context, state){
        if (state is LifeTimeFinancialsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is FetchedLifeTimeFinancials) {
          print('lifetime expenses: ${state.result.length}');
          print('lifetime expenses: ${state.result.isNotEmpty}');
          print('lifetime expenses: ${state.result[0].lifeTimeBalance}');
          if (state.result.isNotEmpty){
            _lifeTimeExpenses = state.result[0].lifeTimeExpenses;
            _lifeTimeIncome = state.result[0].lifeTimeIncome;
            _lifeTimeBalance = state.result[0].lifeTimeBalance;
          }
        }
      },
      child: BlocBuilder<MonthWiseFinancialsBloc, MonthWiseFinancialsState>(
        bloc: widget.monthWiseFinancialsBloc,
        builder: (context, state){
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                      color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                      ),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(18),
                                child: CarmaAppBar(label: ''),
                              ),
                              Text(
                                'All time balance',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _lifeTimeBalance,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Expenses: ',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _lifeTimeExpenses,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    'Income: ',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _lifeTimeIncome,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Month',
                            style: TextStyle(
                              color: AppColors.secondary.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Expenses',
                            style: TextStyle(
                              color: AppColors.secondary.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: AppColors.secondary.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Balance',
                            style: TextStyle(
                              color: AppColors.secondary.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.list.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MonthlyStatsDetailListItem(entity: widget.list[index], isLast: !(index == widget.list.length - 1));
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
