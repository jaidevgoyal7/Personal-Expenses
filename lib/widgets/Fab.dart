import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widgets/new_transaction.dart';
import '../widgets/new_limit.dart';
import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  final deviceHeight;
  final deviceWidth;
  final ScrollController _scrollController;

  Fab(
    this.deviceHeight,
    this.deviceWidth,
    this._scrollController,
  );

  @override
  Widget build(BuildContext context) {
    Future<void> _SetLimit() async {
      return await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: NewLimit(),
            );
          },
        ),
      );
    }

    Future<void> _AddExpense() async {
      return await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: NewTransaction(),
            );
          },
        ),
      );
    }

    return SpeedDial(
      marginBottom: deviceHeight * 0.025,
      marginEnd: deviceWidth * 0.05,
      overlayColor: Colors.black38,
      animatedIcon: AnimatedIcons.menu_home,
      onClose: () {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      },
      animatedIconTheme: IconThemeData(
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).accentColor,
      children: [
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 25,
          ),
          label: "Add expense",
          labelStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.white,
          onTap: () {
            _AddExpense();
          },
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add_alert,
            color: Colors.white,
            size: 25,
          ),
          label: "Set daily limit",
          labelStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.white,
          onTap: () {
            _SetLimit();
          },
        ),
      ],
    );
  }
}
