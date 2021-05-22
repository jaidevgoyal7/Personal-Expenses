import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  final String dayLabel;
  final double spendingAmount;
  final double spendingPrcOfTotalAmount;

  ChartBars({
    this.dayLabel,
    this.spendingAmount,
    this.spendingPrcOfTotalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  '\u{20B9}${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(
                        220,
                        220,
                        220,
                        1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPrcOfTotalAmount,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  dayLabel,
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
