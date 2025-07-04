import 'package:flutter/cupertino.dart';

class FinancialTypeEntity {
  final String? id;
  final String label;
  final bool isSelected;
  final String? imageAsset;
  final Color indicatedColor;
  const FinancialTypeEntity({this.id, required this.label, required this.isSelected, this.imageAsset, required this.indicatedColor});

  FinancialTypeEntity copyWith({String? label, bool? isSelected, String? imageAsset, Color? indicatedColor}) {
    return FinancialTypeEntity(
      id: id,
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
      imageAsset: imageAsset ?? this.imageAsset,
      indicatedColor: indicatedColor ?? this.indicatedColor,
    );
  }

}