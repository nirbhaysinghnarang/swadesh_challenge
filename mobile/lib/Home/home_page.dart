import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swadesh_challenge/Client/api_client.dart';
import 'package:swadesh_challenge/Models/user_data.dart';
import 'package:swadesh_challenge/TransactionForm/transaction_form_page.dart';
import 'package:swadesh_challenge/Widgets/balance_widget.dart';
import 'package:swadesh_challenge/Widgets/transaction_widget.dart';
import 'package:swadesh_challenge/Models/transaction.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Calculate the balance of a user given a list of transactions, with the starting balance as [1000]
  ///Appropriately filters the list of transactions to only include transactions that have been processed.
  ///A processed transaction is a transaction which was initiated at least 10 minutes ago.
  num calculateBalance(List<Transaction> transList) {
    return 1000 -
        transList
            .where((transaction) =>
                DateTime.now().millisecondsSinceEpoch -
                    (transaction.timeStamp * 1000) >
                60000)
            .fold(0,
                (previousValue, element) => (previousValue + element.amount));
  }

  late Future<UserData> userData;
  final client = ApiClient();
  @override
  void initState() {
    super.initState();
    userData = client.fetchData();
  }

  Future<void> _refreshData() {
    return (userData = client.fetchData());
  }

  FutureOr<dynamic> onGoBack(dynamic value) {
    _refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: appBarTitle(),
          ),
        ),
        body: FutureBuilder<UserData>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          divider(),
                          BalanceWidget(
                              balanceAmount: calculateBalance(snapshot
                                      .data!.userTransactions!
                                      .cast<Transaction>()
                                      .toList())
                                  .toStringAsFixed(2)),
                          transactionLabel(),
                          transactionWidget(snapshot.data!.userTransactions)
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return getSkeleton();
            }));
  }

  Widget transactionButton(context) {
    return (Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: ElevatedButton(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: const Center(
                  child: Text(
                    "International Transaction",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                decoration: const BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionFormPage()))
                    .then(onGoBack);
              }),
        )));
  }

  Widget getSkeleton() {
    return (Center(
        child: Expanded(
      child: SkeletonAnimation(
        shimmerColor: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        shimmerDuration: 1000,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(top: 40),
        ),
      ),
    )));
  }

  Widget transactionWidget(List<dynamic>? transactions) {
    if ((transactions ?? []).isEmpty) {
      return (const Center(
          child: Image(
        image: AssetImage('assets/error.png'),
        width: 240,
      )));
    } else {
      final transactionsList = transactions!.cast<Transaction>().toList();

      return Column(
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: _listView(transactionsList)),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: transactionButton(context),
          )
        ],
      );
    }
  }

  Widget _listView(List<Transaction> trans) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LiquidPullToRefresh(
          backgroundColor: Colors.black,
          color: Colors.deepPurpleAccent,
          onRefresh: _refreshData,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: trans.length,
              itemBuilder: (context, index) {
                return TransactionWidget(
                    accHolderName: trans[index].accHolderName,
                    date: trans[index].purposeCode,
                    initTime: trans[index].timeStamp,
                    amount: trans[index].amount);
              })),
    );
  }

  Widget appBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome back.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              'Hi, Nirbhay 👋🏻',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 27),
            ),
          ],
        )
      ],
    );
  }

  Widget transactionLabel() {
    return (const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'Transactions',
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25),
      ),
    ));
  }

  Widget divider() {
    return (const Divider(
      color: Colors.deepPurpleAccent,
      height: 20,
      thickness: 2,
      indent: 16,
      endIndent: 16,
    ));
  }
}
