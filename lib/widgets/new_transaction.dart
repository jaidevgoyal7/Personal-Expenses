import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Transaction_Provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewTransaction extends StatefulWidget {
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _form = GlobalKey<FormState>();
  final _amountFocus = FocusNode();
  final _titleFocus = FocusNode();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _pickedDate = DateTime.now();
  DateTime _currentDate = DateTime.now();

  void _SubmittedFunc(BuildContext context) {
    final isValid = _form.currentState.validate();
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (!isValid) {
      return;
    }
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _pickedDate == null) {
      return;
    }
    Provider.of<TransactionProvider>(context, listen: false).addNewTransaction(
      enteredTitle,
      enteredAmount,
      _pickedDate,
    );

    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then(
      (value) {
        if (value == null) {
          return;
        }
        setState(
          () {
            _pickedDate = value;
            _currentDate = value;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _amountFocus.dispose();
    _titleFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              2, // Make module Scrollable
        ),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the title.';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22,
                    ),
                  ),
                  controller: _titleController,
                  focusNode: _titleFocus,
                  onSaved: (_) {
                    _SubmittedFunc(context);
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocus);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the amount.';
                    }
                  },
                  focusNode: _amountFocus,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22,
                    ),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) => _SubmittedFunc(context),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Picked Date:- ',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _pickedDate == null
                              ? '${DateFormat.yMMMd().format(DateTime.now())}'
                              : '${DateFormat.yMMMd().format(_pickedDate)}',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        onPressed: _datePicker,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      onPressed: () {
                        _SubmittedFunc(context);
                      },
                      child: Text(
                        'Add Expense',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 25,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
