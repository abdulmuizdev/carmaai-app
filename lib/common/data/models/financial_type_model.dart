import 'package:carma/features/add_financial_screen/domain/entities/financial_type_entity.dart';
import 'package:flutter/material.dart';

class FinancialTypeModel extends FinancialTypeEntity {
  final String? id;
  final String label;
  final bool isSelected;
  // TODO: change this icon data to image assets and store their path strings in db
  final String imageAsset;
  final Color indicatedColor;

  FinancialTypeModel(
      {
        this.id,
        required this.label,
      required this.isSelected,
      required this.imageAsset,
      required this.indicatedColor})
      : super(
            id: id,
            label: label,
            isSelected: isSelected,
            imageAsset: imageAsset,
            indicatedColor: indicatedColor);

  // This directly reflects to database only
  factory FinancialTypeModel.fromJson(Map<String, dynamic> raw) {
    return FinancialTypeModel(
      id: raw['id'].toString(),
      label: raw['name'],
      imageAsset: raw['image_asset'],
      isSelected: false,
      indicatedColor: Color(int.tryParse(raw['color']) ?? 0xFF),
    );
  }
}
