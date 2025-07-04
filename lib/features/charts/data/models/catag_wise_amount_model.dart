import 'dart:ui';

import 'package:carma/features/charts/domain/entities/catag_wise_amount_entity.dart';

class CatagWiseAmountModel extends CatagWiseAmountEntity {
  final String category;
  final String imageAsset;
  final Color color;
  final String amount;

  const CatagWiseAmountModel({
    required this.category,
    required this.imageAsset,
    required this.amount,
    required this.color,
  }) : super(
          category: category,
          imageAsset: imageAsset,
          amount: amount,
          color: color,
        );

// factory CatagWiseAmountModel.fromJson(Map<String, dynamic> raw) {
//   return CatagWiseAmountModel(
//     category: raw['category'],
//     amount: raw['amount'],
//     color: raw['color'],
//   );
// }
}
