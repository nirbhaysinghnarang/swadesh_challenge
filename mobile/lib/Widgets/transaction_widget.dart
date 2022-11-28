import 'package:flutter/material.dart';
import 'package:avatars/avatars.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatefulWidget {
  final String? accHolderName;
  final String? date;
  final num? amount;
  final num? initTime;

  static num processingTime = 600000;
  TransactionWidget(
      {Key? key, this.accHolderName, this.date, this.amount, this.initTime})
      : super(key: key);

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  static const paddingStyle =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          nameDateWidget(
              widget.accHolderName ?? "",
              widget.date ?? "",
              DateTime.now().millisecondsSinceEpoch! -
                      (widget.initTime! * 1000) <
                  TransactionWidget.processingTime),
          Text(
            (DateTime.now().millisecondsSinceEpoch - (widget.initTime! * 1000) <
                    TransactionWidget.processingTime
                ? "-"
                : '\$${widget.amount?.toStringAsFixed(2)}'),
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.red, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget nameDateWidget(String name, String date, bool isProcessing) {
    final DateTime dateTime =
        DateTime.fromMicrosecondsSinceEpoch(widget.initTime!.toInt() * 1000000);
    final String dateString = DateFormat("d MMM, h:mm a").format(dateTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Avatar(
              name: isProcessing ? "Processing" : name,
              shape: AvatarShape.circle(25),
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isProcessing ? "Processing" : name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  constraints:
                      const BoxConstraints(minWidth: 10, maxWidth: 150),
                  child: Text(
                    isProcessing ? "Initiated on $dateString" : dateString,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
