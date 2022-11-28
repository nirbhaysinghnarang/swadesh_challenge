import 'transaction.dart';

///This class represents a blueprint for user data.
///Was created keeping future concerns in mind, if there is a need to store more
///information related to a user such as name, age, etc.
///For now, the only information kept track of is a list of transactions.
class UserData {
  ///Instance variables
  List<Transaction>? userTransactions = [];

  ///Constructor
  UserData({this.userTransactions});

  /// Constructs an instance of this class given a JSON string.
  /// Parameter [json: Map<String, dynamic>]
  /// Precondition: [json] is valid JSON and contains a list field called ["transactions"]
  /// Each member of [json["transactions"] must satisfy the precondition in
  /// [Transaction.fromJson()]]
  factory UserData.fromJson(Map<String, dynamic> json) {
    final jsonList = json["transactions"];
    var transactionList = [];
    for (var i = 0; i < jsonList.length; i++) {
      final transaction = Transaction.fromJson(jsonList[i]);
      transactionList.add(transaction);
    }
    return UserData(userTransactions: transactionList.cast<Transaction>());
  }
}
