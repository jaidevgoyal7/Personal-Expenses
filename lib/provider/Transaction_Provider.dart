import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../helper/DB_Helper.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _items = [];
  List<Transaction> get items {
    return [..._items];
  }

  Future<void> fetchAndSetTransaction() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    _items = maps
        .map(
          (e) => Transaction(
            id: e['id'],
            title: e['title'],
            amount: e['amount'],
            date: DateTime.parse(e['date']),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<Transaction> get recentTransactions {
    return _items.where(
      (transaction1) {
        return transaction1.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  SplayTreeMap<DateTime, List<Transaction>> get itemMap {
    var m2 = new SplayTreeMap<DateTime, List<Transaction>>();
    for (var i = 0; i < _items.length; i++) {
      if (!m2.containsKey(DateFormat('yyyy-MM-dd').format(_items[i].date))) {
        m2[DateTime.parse(DateFormat('yyyy-MM-dd').format(_items[i].date))] =
            _items.where((element) {
          return DateFormat('yyyy-MM-dd').format(element.date) ==
              DateFormat('yyyy-MM-dd').format(_items[i].date);
        }).toList();
      }
    }
    var m = new SplayTreeMap<DateTime, List<Transaction>>.from(
        m2, (a, b) => a.isBefore(b) ? 1 : -1);
    return m;
  }

  double get dailyTotal {
    double total = 0.0;
    for (var i = 0; i < _items.length; i++) {
      if (DateFormat('yyyy-MM-dd').format(_items[i].date) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        total += _items[i].amount;
      }
    }
    return total;
  }

  Future<void> addNewTransaction(
      String txTitle, double txAmount, DateTime txDate) async {
    // final sId = UniqueKey().toString();
    final String sId = DateTime.now().toString();
    await DBHelper.insert('transactions', {
      'id': sId,
      'title': txTitle,
      'amount': txAmount,
      'date': txDate.toString(),
    });
    final addTx = Transaction(
      id: sId,
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );
    _items.add(addTx);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await DBHelper.delete('transactions', id);
    _items.removeWhere(
      (element) {
        return element.id == id;
      },
    );
    notifyListeners();
  }
}
