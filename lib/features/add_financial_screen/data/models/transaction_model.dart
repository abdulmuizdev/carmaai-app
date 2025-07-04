import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  final int? id;
  final int type;
  final String categoryId;
  final String categoryName;
  final String? imageAsset;
  final String amount;
  final String date;
  final String time;
  final String notes;

  TransactionModel({
    this.id,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    this.imageAsset,
    required this.amount,
    required this.date,
    required this.time,
    required this.notes,
  }) : super(
          id: id,
          type: type,
          categoryId: categoryId,
          categoryName: categoryName,
          imageAsset: imageAsset,
          amount: amount,
          notes: notes,
          date: date,
          time: time,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> raw) {
    print(raw);
    return TransactionModel(
      id: raw['id'],
      type: int.tryParse(raw['type']) ?? -1,
      categoryId: raw['category_id'],
      categoryName: raw['category_name'],
      imageAsset: raw['image_asset'],
      amount: raw['amount'],
      date: Utils.convertFromIso8601(raw['date']),
      time: raw['time'],
      notes: raw['notes'],
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
        id: entity.id,
        type: entity.type,
        categoryId: entity.categoryId,
        categoryName: entity.categoryName,
        imageAsset: entity.imageAsset,
        amount: entity.amount,
        date: entity.date,
        time: entity.time,
        notes: entity.notes);
  }
}
