import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class WeekChart extends StatefulWidget {
  final List<Transaction> recentTransactions;
  WeekChart(this.recentTransactions);
  @override
  State<StatefulWidget> createState() => WeekChartState();
}

class WeekChartState extends State<WeekChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  List<int> get day {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      int x;
      if (DateFormat.E().format(weekDay).substring(0, 2) == 'Mo') {
        x = 0;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'Tu') {
        x = 1;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'We') {
        x = 2;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'Th') {
        x = 3;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'Fr') {
        x = 4;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'Sa') {
        x = 5;
      } else if (DateFormat.E().format(weekDay).substring(0, 2) == 'Su') {
        x = 6;
      }
      return x;
    }).reversed.toList();
  }

  List<double> get amount {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      if (widget.recentTransactions.isEmpty) {
        return 0.0;
      } else {
        double totalSum = 0.0;
        for (var i = 0; i < widget.recentTransactions.length; i++) {
          if (widget.recentTransactions[i].date.day == weekDay.day &&
              widget.recentTransactions[i].date.month == weekDay.month &&
              widget.recentTransactions[i].date.year == weekDay.year) {
            totalSum += widget.recentTransactions[i].amount;
          }
        }
        return totalSum;
      }
    }).reversed.toList();
  }

  double get totalSpending {
    var sum = 0.0;
    for (var i = 0; i < amount.length; i++) {
      sum += amount[i];
    }
    return sum == 0.0 ? 100.0 : sum;
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.teal,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 18,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.redAccent] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: totalSpending,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(day[i], amount[i] == 0.0 ? 0.0 : amount[i],
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            direction: TooltipDirection.top,
            fitInsideVertically: true,
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\u{20B9}' + (rod.y - 1).toString(),
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff0f4a3c),
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}
