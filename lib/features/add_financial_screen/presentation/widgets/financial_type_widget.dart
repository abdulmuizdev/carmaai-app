import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:carma/common/widgets/grey_circle.dart';
import 'package:flutter/material.dart';

class FinancialTypeWidget extends StatelessWidget {
  final FinancialTypeEntity entity;
  const FinancialTypeWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GreyCircle(isSelected: entity.isSelected, imageAsset: entity.imageAsset,),
          const SizedBox(height: 4),
          Expanded(
            child: Text(entity.label, overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );
  }
}
