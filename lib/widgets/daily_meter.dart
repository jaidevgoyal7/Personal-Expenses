import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../provider/Transaction_Provider.dart';

class DailyMeter extends StatefulWidget {
  @override
  _DailyMeterState createState() => _DailyMeterState();
}

class _DailyMeterState extends State<DailyMeter> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<double> _limitValue;
  double d;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _limitValue = _prefs.then((SharedPreferences prefs) {
        return (prefs.getDouble('Limitkey') ?? 500.0);
      });
    });
    double val =
        Provider.of<TransactionProvider>(context, listen: false).dailyTotal;

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<double>(
            future: _limitValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                d = snapshot.data;
              } else {
                return Center(child: CircularProgressIndicator());
              }
              return SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 2000,
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: d,
                    labelFormat: ' \u{20B9}{value}',
                    axisLabelStyle: GaugeTextStyle(
                      fontFamily: 'OpenSans',
                    ),
                    interval: d / 4,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: d / 2,
                        color: Colors.green,
                      ),
                      GaugeRange(
                        startValue: d / 2,
                        endValue: d / 2 + d / 4,
                        color: Colors.orange,
                      ),
                      GaugeRange(
                        startValue: d / 2 + d / 4,
                        endValue: d,
                        color: Colors.red,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: val,
                        enableAnimation: true,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Container(
                          child: Text(
                            '\u{20B9}$val',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 1,
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
