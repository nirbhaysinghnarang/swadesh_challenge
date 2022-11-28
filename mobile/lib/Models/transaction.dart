import 'dart:convert';

///Represents a transaction.
class Transaction {
  /// Instance variables.
  final num amount;
  final String accHolderName;
  final num accNo;
  final num routingNo;
  final String? desc;
  final String purposeCode;

  /// timeStamp is a UNIX timestamp (seconds since last epoch [time.time() in Python])
  final num timeStamp;

  /// Constructor
  const Transaction({
    required this.amount,
    required this.timeStamp,
    required this.accHolderName,
    required this.accNo,
    required this.routingNo,
    required this.purposeCode,
    this.desc,
  });

  /// Constructs an instance of this class given a JSON string.
  /// Parameter [json:Map<String,dynamic>] the JSON string that represents this transaction.
  /// Preconditition: [json] is valid JSON and contains the following fields with the following types:\
  /// 1.[amount]: numeric string representing a floating point number
  /// 2. [timeStamp]: numeric string representing a floating point number
  /// 3. [accHolderName]: string
  /// 4. [routingNumber]: numeric string representing an integer
  /// 5. [purposeCode]: string
  /// 6. [accNo]:numeric string representing an integer
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

  /// Encodes an instance of this class to a JSON string.
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
