import 'dart:convert';

class Transaction {
  final num amount;
  final String accHolderName;
  final num accNo;
  final num routingNo;
  final num timeStamp;
  final String? desc;
  final String purposeCode;

  const Transaction({
    required this.amount,
    required this.timeStamp,
    required this.accHolderName,
    required this.accNo,
    required this.routingNo,
    required this.purposeCode,
    this.desc,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        amount: double.parse(json['amount']),
        timeStamp: double.parse(json['initTime']),
        accHolderName: json['accHolderName'],
        desc: json['desc'],
        routingNo: int.parse(json['routingNo']),
        purposeCode: json['purposeCode'],
        accNo: int.parse(json['accNo']));
  }

  String toJson() {
    return jsonEncode({
      'amount': amount,
      'accHolderName': accHolderName,
      'desc': desc,
      'routingNo': routingNo,
      'purposeCode': purposeCode,
      'accNo': accNo
    });
  }
}
