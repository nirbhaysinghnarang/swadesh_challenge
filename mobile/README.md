
# `/lib` directory overview:
1. `/client/apiClient.dart`: Defines a class to make GET/POST requests to the API.
2. `/Home/home_page.dart`: Defines the semantics and styling of the home page.
3. `/Models/transaction.dart`: Defines a class to represent a transaction, with utility methods to encode/decode a transaction object from a JSON string.
4. `/Models/user_data.dart`: Defines a class to store user data. For now, this is a list of transactions, but could potentially include more information about the user (name,address, etc.). Made the decision to not have a field for user balance because the user balance is only a function of transactions (every user starts with the same amount). This made dealing with processing transactions easier.
5. `/TransactionForm/transaction_form.dart`: efines the semantics and styling of the transaction form page.
6. `/Widgets/balance_widget.dart`: Refactored widget to display balance on home page.
7. `/Widgets/transaction_form_widget.dart`: Refactored widget to structure text fields and etc. on transaction form page.
8. `/Widgets/transaction_widget.dart`: Refactored widget to display a transaction as a cell on the home page.