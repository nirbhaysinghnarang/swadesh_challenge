import 'transaction.dart';

class UserData {
  List<dynamic>? userTransactions = [];

  UserData({this.userTransactions});

  factory UserData.fromJson(Map<String, dynamic> json) {
    final jsonList = json["transactions"];
    var transactionList = [];
    for (var i = 0; i < jsonList.length; i++) {
      final transaction = Transaction.fromJson(jsonList[i]);
      transactionList.add(transaction);
    }
    return UserData(userTransactions: transactionList);
  }
}
