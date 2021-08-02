import 'package:Personal_Expenses/widgets/transaction_list.dart';
import '../provider/Transaction_Provider.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class TransactionCard extends StatelessWidget {
  SplayTreeMap<DateTime, List<Transaction>> m;
  final deviceWidth;
  ScrollController _scrollController;
  TransactionCard(this.m, this.deviceWidth, this._scrollController);

  double dailytotal(BuildContext context, DateTime dt) {
    final List<Transaction> temp = Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).items;
    double total = 0.0;
    for (var i = 0; i < temp.length; i++) {
      if (DateTime.parse(DateFormat('yyyy-MM-dd').format(temp[i].date)) == dt) {
        total += temp[i].amount;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<TransactionProvider>(context).fetchAndSetTransaction(),
      builder: (context, snapshot) => Consumer<TransactionProvider>(
        builder: (context, transaction, ch) => transaction.itemMap.isEmpty
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
            : m.isEmpty
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Loading...',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.title,
                          )
                        ]),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 15, top: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        DateFormat('dd')
                                            .format(m.keys.elementAt(index)),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            DateFormat.EEEE().format(
                                                m.keys.elementAt(index)),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                          Text(
                                            '${DateFormat.MMM().format(m.keys.elementAt(index))} ${DateFormat.y().format(m.keys.elementAt(index))}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      '- \u{20B9}${dailytotal(context, m.keys.elementAt(index))}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                indent: deviceWidth * 0.124,
                                thickness: 1.5,
                              ),
                              TransactionList(m.values.elementAt(index)),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: m.length,
                  ),
      ),
    );
  }
}
