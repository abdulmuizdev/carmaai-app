import 'package:carma/common/widgets/grey_circle.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/charts/presentation/pages/widget/carma_progress_bar.dart';
import 'package:flutter/material.dart';

class ChartDetailCell extends StatefulWidget {
  final bool isLast;
  final String label;
  final String? imageAsset;
  final String amount;
  final double weightage;

  const ChartDetailCell({
    super.key,
    required this.isLast,
    required this.label,
    this.imageAsset,
    required this.amount,
    required this.weightage,
  });

  @override
  State<ChartDetailCell> createState() => _ChartDetailCellState();
}

class _ChartDetailCellState extends State<ChartDetailCell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 37,
                      height: 37,
                      child: GreyCircle(isSelected: true, imageAsset: widget.imageAsset),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.label,
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${(widget.weightage * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          CarmaProgressBar(progress: widget.weightage),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              Utils.formatNumber(widget.amount) ?? '--',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!(widget.isLast))
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: AppColors.primary.withOpacity(0.2),
          )
      ],
    );
  }
}
