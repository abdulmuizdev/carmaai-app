class TransactionEntity {
  final int? id;
  final int type;
  final String categoryId;
  final String categoryName;
  final String? imageAsset;
  final String amount;
  final String date;
  final String time;
  final String notes;

  const TransactionEntity(
      {this.id,
      required this.type,
      required this.categoryId,
      required this.categoryName,
      this.imageAsset,
      required this.amount,
      required this.date,
      required this.time,
      required this.notes});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageAsset': imageAsset,
      'amount': amount,
      'date': date,
      'time': time,
      'notes': notes,
    };
  }

}
