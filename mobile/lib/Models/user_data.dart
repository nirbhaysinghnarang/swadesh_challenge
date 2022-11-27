import 'transaction.dart';

class UserData {
  num? userBalance = 1000;
  List<dynamic>? userTransactions = [];

  UserData({this.userBalance, this.userTransactions});

  factory UserData.fromJson(Map<String, dynamic> json) {
    final jsonList = json["transactions"];
    var transactionList = [];
    for (var i = 0; i < jsonList.length; i++) {
      final transaction = Transaction.fromJson(jsonList[i]);
      transactionList.add(transaction);
    }
    return UserData(
        userBalance: double.parse((json['userBalance'])),
        userTransactions: transactionList);
  }
}
