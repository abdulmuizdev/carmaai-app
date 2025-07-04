import 'dart:ui';

class CatagWiseAmountEntity {
  final String category;
  final String? imageAsset;
  final String amount;
  final Color color;
  final double? weightage;

  const CatagWiseAmountEntity({
    required this.category,
    this.imageAsset,
    required this.amount,
    required this.color,
    this.weightage,
  });

  CatagWiseAmountEntity copyWith({
    String? category,
    String? imageAsset,
    String? amount,
    Color? color,
    double? weightage,
  }) {
    return CatagWiseAmountEntity(
      category: category ?? this.category,
      imageAsset: imageAsset ?? this.imageAsset,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      weightage: weightage ?? this.weightage,
    );
  }
}
