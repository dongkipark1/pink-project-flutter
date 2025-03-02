class TransactionSaveDTO {
  // final userId;
  final transactionType;
  final yearMonthDate;
  final time;
  final amount;
  final categoryIn;
  final categoryOut;
  final assets;
  final description;

  TransactionSaveDTO({
    // this.userId,
    this.transactionType,
    this.yearMonthDate,
    this.time,
    this.amount,
    this.categoryIn,
    this.categoryOut,
    this.assets,
    this.description});

  Map<String, dynamic> toJson() =>
      {
        // "userId": userId,
        "transactionType": transactionType,
        "yearMonthDate": yearMonthDate,
        "time": time,
        "amount": amount,
        "categoryIn": categoryIn,
        "categoryOut": categoryOut,
        "assets": assets,
        "description": description
      };
}
