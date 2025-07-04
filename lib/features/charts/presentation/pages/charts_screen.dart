import 'package:carma/common/widgets/type_selection_tab.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';
import 'package:carma/features/charts/domain/entities/month_wise_financial_entity.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_state.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_state.dart';
import 'package:carma/features/charts/presentation/pages/widget/chart_detail_cell.dart';
import 'package:carma/features/charts/presentation/pages/widget/date_selector.dart';
import 'package:carma/features/charts/presentation/pages/widget/grey_chart.dart';
import 'package:carma/features/charts/presentation/pages/widget/legend_item.dart';
import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/pages/widget/lifetime_financial_widget/lifetime_financial_widget.dart';
import 'package:carma/features/charts/presentation/pages/widget/monthly_financial_widget/monthly_financial_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsScreen extends StatefulWidget {
  final CategoryWiseAmountBloc catagWiseAmountBloc;
  final MonthWiseFinancialsBloc monthWiseFinancialsBloc;

  const ChartsScreen(
      {super.key,
      required this.catagWiseAmountBloc,
      required this.monthWiseFinancialsBloc});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  List<CatagWiseAmountEntity> data = [];
  List<CatagWiseAmountEntity> _incomeData = [];
  List<CatagWiseAmountEntity> _expenseData = [];

  List<MonthWiseFinancialEntity> _monthWiseFinancials = [];
  List<LifetimeFinancialsEntity> _lifeTimeFinancials = [];

  String _totalIncome = '';
  String _totalExpenses = '';

  int _selectedTabIndex = 0;

  String totalAmount = '--';

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonthWiseFinancialsBloc, MonthWiseFinancialsState>(
      bloc: widget.monthWiseFinancialsBloc,
      listener: (context, state) {
        if (state is FetchedMonthWiseFinancial) {
          _monthWiseFinancials = state.result;
        }

        if (state is MonthWiseFinancialError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }

        if (state is FetchedLifeTimeFinancials) {
        _lifeTimeFinancials = state.result;
        }

        if (state is LifeTimeFinancialsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocListener<CategoryWiseAmountBloc, CatagWiseAmountState>(
        bloc: widget.catagWiseAmountBloc,
        listener: (context, state) {
          if (state is FetchedCatagWiseAmount) {
            _incomeData = state.income;
            _totalIncome = state.totalIncome;

            _expenseData = state.expenses;
            _totalExpenses = state.totalExpenses;

            print('total expenses are these');
            print(_totalExpenses);

            _updateData();
          }
          if (state is CatagWiseAmountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<MonthWiseFinancialsBloc, MonthWiseFinancialsState>(
          builder: (context, state) {
            return BlocBuilder<CategoryWiseAmountBloc, CatagWiseAmountState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: AppColors.white,
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
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    TypeSelectionTab(
                                      onSelectionChange: (selectedIndex) {
                                        setState(() {
                                          _selectedTabIndex = selectedIndex;
                                          _updateData();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: LifeTimeFinancialWidget(
                                      list: _lifeTimeFinancials,
                                      list2: _monthWiseFinancials,
                                      monthWiseFinancialsBloc:
                                          widget.monthWiseFinancialsBloc,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(10),
                                  //   child: MonthlyFinancialWidget(
                                  //     list: _monthWiseFinancials,
                                  //     monthWiseFinancialsBloc:
                                  //         widget.monthWiseFinancialsBloc,
                                  //   ),
                                  // ),
                                  DateSelector(
                                      catagWiseAmountBloc:
                                          widget.catagWiseAmountBloc),
                                  if (data.isNotEmpty) ...[
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: Stack(
                                                  children: [
                                                    PieChart(
                                                      duration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      PieChartData(
                                                        sectionsSpace: 1,
                                                        sections:
                                                            List.generate(
                                                          data.length,
                                                          (index) {
                                                            return PieChartSectionData(
                                                              color:
                                                                  data[index]
                                                                      .color,
                                                              value: double.tryParse(
                                                                      data[index]
                                                                          .amount) ??
                                                                  0,
                                                              // title: data[index].category,
                                                              showTitle:
                                                                  false,
                                                              radius: 20,
                                                              titleStyle:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        Utils.formatNumber(
                                                                totalAmount) ??
                                                            '-',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return LegendItem(
                                                        color:
                                                            data[index].color,
                                                        label: data[index]
                                                            .category);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Container(
                                            // height: 243,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withOpacity(0.2),
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: data.length,
                                              itemBuilder: (context, index) {
                                                return ChartDetailCell(
                                                    isLast: index ==
                                                        data.length - 1,
                                                    label:
                                                        data[index].category,
                                                    imageAsset: data[index]
                                                        .imageAsset,
                                                    amount:
                                                        data[index].amount,
                                                    weightage: data[index]
                                                            .weightage ??
                                                        0);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    GreyChart(),
                                  ],
                                  SizedBox(height: 18),
                                  SizedBox(height: 18),
                                  SizedBox(height: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _updateData() {
    if (_selectedTabIndex == 0) {
      data = _expenseData;
      totalAmount = _totalExpenses;
    } else {
      data = _incomeData;
      totalAmount = _totalIncome;
    }
  }
}
