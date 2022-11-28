import 'package:flutter/material.dart';

class BalanceWidget extends StatefulWidget {
  final String? balanceAmount;

  const BalanceWidget({Key? key, this.balanceAmount}) : super(key: key);

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  static const paddingStyle =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Balance',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white, fontSize: 25),
          ),
          Text(
            '\$ ${widget.balanceAmount}',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
