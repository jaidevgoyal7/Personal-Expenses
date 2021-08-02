import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NewLimit extends StatefulWidget {
  @override
  _NewLimitState createState() => _NewLimitState();
}

class _NewLimitState extends State<NewLimit> {
  final _form = GlobalKey<FormState>();
  final _limitFocus = FocusNode();
  final _limitController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<double> _limitValue;
  Future<void> _setLimit() async {
    final isValid = _form.currentState.validate();
    final enteredLimit = double.parse(_limitController.text);
    if (!isValid) {
      return;
    }
    final SharedPreferences prefs = await _prefs;
    final double invalue = prefs.getDouble('Limitkey');

    setState(() {
      _limitValue = prefs.setDouble('Limitkey', enteredLimit).then((value) {
        return invalue;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    _limitValue = _prefs.then((SharedPreferences prefs) {
      return (prefs.getDouble('Limitkey'));
    });
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
          child: FutureBuilder<double>(
            initialData: 500.0,
            builder: (context, snapshot) => Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Default limit = \u{20B9}${snapshot.data == null ? 500.0 : snapshot.data}',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the limit.';
                      }
                      if (double.parse(value) >= 50000.0) {
                        return 'Limit must be less than \u{20B9}50000';
                      }
                    },
                    focusNode: _limitFocus,
                    decoration: InputDecoration(
                      labelText: 'Enter daily limit',
                      labelStyle: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 22,
                      ),
                    ),
                    controller: _limitController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _setLimit();
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        onPressed: () {
                          _setLimit();
                        },
                        child: Text(
                          'Save',
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
            future: _limitValue,
          ),
        ),
      ),
    );
  }
}
