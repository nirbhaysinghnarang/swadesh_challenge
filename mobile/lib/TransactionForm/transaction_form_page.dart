import 'package:flutter/material.dart';
import 'package:swadesh_challenge/Widgets/transaction_form_widget.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({Key? key}) : super(key: key);
  // Fields in a Widget subclass are always marked "final".
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "International Transaction",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  TransactionFormWidget()
                ]),
          ),
        ),
      ),
    );
  }
}
