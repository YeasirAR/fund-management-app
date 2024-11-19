class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      date: json['date'],
    );
  }
}
