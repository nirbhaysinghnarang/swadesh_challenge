import 'package:flutter/material.dart';
import 'package:swadesh_challenge/Client/api_client.dart';
import 'package:swadesh_challenge/Models/transaction.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransactionFormWidget extends StatefulWidget {
  const TransactionFormWidget({Key? key}) : super(key: key);

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

InputDecoration _getTextFieldDecoration(String fieldName, String hintText) {
  return InputDecoration(
      enabledBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusColor: Colors.grey,
      fillColor: Colors.white,
      labelText: fieldName,
      labelStyle: const TextStyle(color: Colors.white),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey));
}

class _TransactionFormWidgetState extends State<TransactionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final accNameController = TextEditingController();
  final accNoController = TextEditingController();
  final routingNoController = TextEditingController();
  final amountController = TextEditingController();
  final descController = TextEditingController();

  bool _isLoading = false;
  String _purposeCode = "";

  final ApiClient client = ApiClient();
  final List<String> _purposeCodes = [
    "P1301 - Inward remittance from NRI",
    "P1302 - Personal gifts and donations",
    "P1306 - Receipts / Refund of taxes",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Expanded(
        child: Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent)),
      );
    }
    return Expanded(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: accNameController,
                style: const TextStyle(color: Colors.white),
                decoration: _getTextFieldDecoration(
                    "Account Holder Name", "Enter Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (value.length > 100) {
                    return 'Name cannot exceed 100 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: accNoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                style: const TextStyle(color: Colors.white),
                decoration: _getTextFieldDecoration(
                    "Account Number", "Enter Account Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (num.tryParse(value) == null) {
                    return "Account number must be numeric.";
                  } else if (value.length > 12) {
                    return 'Number cannot exceed 12 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: routingNoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                style: const TextStyle(color: Colors.white),
                decoration: _getTextFieldDecoration(
                    "Routing Number", "Enter Routing Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (num.tryParse(value) == null) {
                    return "Routing number must be numeric.";
                  } else if (value.length > 9) {
                    return 'Routing number cannot exceed 9 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: _getTextFieldDecoration("Amount", "Enter amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (num.tryParse(value) == null) {
                    return "Routing number must be numeric.";
                  } else if (num.tryParse(value)! > 10000) {
                    return 'Transaction amounts cannot exceed USD 10,000';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descController,
                minLines: 2,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _getTextFieldDecoration("Description", "Enter description"),
                validator: (value) {
                  if (value!.split(" ").length > 200) {
                    return 'Description cannot exceed 200 words.';
                  }
                  return null;
                },
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  decoration: _getTextFieldDecoration(
                      "Purpose Code", "Choose Purpose Code"),
                  hint: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Purpose Code",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  value: _purposeCode != "" ? _purposeCode : null,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a purpose code.';
                    }
                  },
                  onChanged: (String? value) {
                    setState(() {
                      _purposeCode = value!;
                    });
                  },
                  items: _purposeCodes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    child: Container(
                      child: const Center(
                        child: Text(
                          "Make payment",
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Fluttertoast.showToast(
                            msg: "Processing...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                const Color.fromRGBO(236, 232, 26, 1),
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          _isLoading = true;
                        });
                        final newTrans = Transaction(
                            amount: num.parse(amountController.text),
                            accHolderName: accNameController.text,
                            accNo: num.parse(accNoController.text),
                            routingNo: num.parse(routingNoController.text),
                            timeStamp: 0,
                            purposeCode: _purposeCode);
                        client.addTransaction(newTrans).then((response) =>
                            setState(() {
                              _isLoading = false;
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: "Success!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        const Color.fromRGBO(75, 181, 67, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('An error occured.')));
                              }
                            }));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
