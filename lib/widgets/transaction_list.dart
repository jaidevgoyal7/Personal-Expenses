import 'package:Personal_Expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function _deleteTransaction;
  TransactionList(this._userTransactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return _userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'images/NoTransaction.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'No transaction added yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (cdx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                            '\u{20B9} ${_userTransactions[index].amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    _userTransactions[index].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(_userTransactions[index].date),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          onPressed: () => _deleteTransaction(
                            _userTransactions[index].id,
                          ),
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text('Delete'),
                          textColor: Theme.of(context).errorColor,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () =>
                              _deleteTransaction(_userTransactions[index].id),
                        ),
                ),
              );
            },
            itemCount: _userTransactions.length,
          );
  }
}
