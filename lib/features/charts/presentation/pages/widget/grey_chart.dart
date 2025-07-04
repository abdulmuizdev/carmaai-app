import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/presentation/pages/widget/chart_detail_cell.dart';
import 'package:carma/features/charts/presentation/pages/widget/legend_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GreyChart extends StatelessWidget {
  const GreyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
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
                          duration: const Duration(
                              milliseconds: 500),
                          PieChartData(
                            sectionsSpace: 1,
                            sections: List.generate(
                              1,
                                  (index) {
                                return PieChartSectionData(
                                  color: Colors.grey,
                                  value: 100,
                                  showTitle: false,
                                  radius: 20,
                                  titleStyle:
                                  const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Center(
                          child: Text('--',
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
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return const LegendItem(
                            color: Colors.grey,
                            label: '--');
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
                  borderRadius: BorderRadius.circular(13),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ChartDetailCell(
                        isLast: true,
                        label: '--',
                        amount: '--',
                        weightage: 0);
                  },
                ),
              ),
            ),
          ],
        ),
      );
  }
}
