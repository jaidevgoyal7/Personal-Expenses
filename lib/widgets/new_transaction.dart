import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _pickedDate = DateTime.now();
  DateTime _currentDate = DateTime.now();

  void _SubmittedFunc() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _pickedDate == null) {
      return;
    }
    widget.addTx(
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 13,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              30, // Make module Scrollable
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 24,
                ),
              ),
              controller: _titleController,
              onSubmitted: (val) => _SubmittedFunc(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 24,
                ),
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (val) => _SubmittedFunc(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _pickedDate == null
                          ? 'Picked Date : ${DateFormat.yMMMd().format(DateTime.now())}'
                          : 'Picked Date : ${DateFormat.yMMMd().format(_pickedDate)}',
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    onPressed: _datePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: _SubmittedFunc,
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 25,
                ),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
