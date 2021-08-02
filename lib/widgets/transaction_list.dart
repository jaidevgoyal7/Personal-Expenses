import '../provider/Transaction_Provider.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  List<Transaction> dailyItems = [];
  TransactionList(this.dailyItems);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Dismissible(
        key: Key(dailyItems[index].id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Text(
                'Are you sure?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Do you really want to delete this record? This process cannot be undone.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Provider.of<TransactionProvider>(
                            context,
                            listen: false,
                          ).deleteTransaction(dailyItems[index].id);
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'OpenSans'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        onDismissed: (DismissDirection direction) {
          Provider.of<TransactionProvider>(
            context,
            listen: false,
          ).deleteTransaction(dailyItems[index].id);
        },
        background: Container(
          color: Theme.of(context).accentColor,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 24,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 20,
            ),
            backgroundColor: Colors.teal,
            maxRadius: 12,
          ),
          title: Text(
            dailyItems[index].title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            '- \u{20B9}${dailyItems[index].amount}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      itemCount: dailyItems.length,
    );
  }
}
