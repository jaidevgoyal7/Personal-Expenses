import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.redAccent,
        fontFamily: 'BlackOpsOne',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 33,
                ),
              ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'VT323',
                fontSize: 28,
              ),
            ),
        // primaryTextTheme: ThemeData.light().textTheme.copyWith(
        //       title: TextStyle(
        //         fontFamily: 'VT323',
        //         fontSize: 24,
        //         color: Colors.black,
        //       ),
        //     ),
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Milk',
    //   amount: 28,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Curd',
    //   amount: 36,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (transaction1) {
        return transaction1.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  bool _LandscapeMode = false;

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final addTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );
    setState(() {
      _userTransactions.add(addTx);
    });
  }

  void _AddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
      builder: (btx) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(
      () {
        _userTransactions.removeWhere(
          (element) {
            return element.id == id;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandsacpe =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      backgroundColor: Colors.teal,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _AddModal(context),
        ),
      ],
    );
    final txWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.75,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandsacpe)
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Charts',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Switch(
                        value: _LandscapeMode,
                        onChanged: (val) {
                          setState(
                            () {
                              _LandscapeMode = val;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (!isLandsacpe)
                Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.25,
                  child: Chart(_recentTransactions),
                ),
              if (!isLandsacpe) txWidget,
              if (isLandsacpe)
                _LandscapeMode
                    ? Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                50 -
                                MediaQuery.of(context).padding.top) *
                            0.79,
                        child: Chart(_recentTransactions),
                      )
                    : txWidget,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _AddModal(context),
      ),
    );
  }
}
