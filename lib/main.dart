import './widgets/transaction_card.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import './widgets/Fab.dart';
import './provider/Transaction_Provider.dart';
import 'package:flutter/rendering.dart';
import './widgets/week_chart.dart';
import './widgets/daily_meter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(
    callbackDispatcher,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider.value(
        value: TransactionProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Personal Xpense',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.redAccent,
            fontFamily: 'OpenSans',
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 25,
                  ),
                ),
          ),
          home: MyApp(),
        ),
      ),
    );
  });
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('icon');

    var settings = new InitializationSettings(
      android: android,
    );
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    "jaidevgoyal7",
    "Jaidev Goyal",
    "Today's Expense",
    onlyAlertOnce: true,
    importance: Importance.max,
    priority: Priority.max,
  );

  var platformChannelSpecifics = new NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flip.show(
    0,
    "Forget to add expenses?",
    "Add them now before they will be skipped from your mind.",
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return SplashScreenView(
      navigateRoute: MyHome(),
      duration: 3800,
      imageSrc: "images/SplashScreen.gif",
      backgroundColor: Colors.white,
      imageSize: (deviceHeight - 20).round(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _hideAnimation;

  bool showFab = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _hideAnimation = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1),
      value: 1,
    );
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          _hideAnimation.forward();
          break;
        case ScrollDirection.reverse:
          _hideAnimation.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final List<Widget> card = [
      WeekChart(Provider.of<TransactionProvider>(context).recentTransactions),
      DailyMeter(),
    ];

    Workmanager.registerPeriodicTask(
      "2",
      "simplePeriodicTask",
      frequency: Duration(hours: 13,),
    );

    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.forward ||
                _scrollController.position.pixels == 0) {
              showFab = false;
            } else if (notification.direction == ScrollDirection.reverse) {
              showFab = true;
            }
          });
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 28,
                ),
              ),
              Container(
                height: (deviceHeight -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.27,
                width: double.infinity,
                child: Swiper(
                  itemBuilder: (context, index) {
                    return card[index];
                  },
                  itemCount: card.length,
                  viewportFraction: 1,
                  scale: 0.9,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(
                      bottom: 2,
                    ),
                    builder: new DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: Colors.teal,
                    ),
                  ),
                  loop: true,
                ),
              ),
              Container(
                height: (deviceHeight -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.75,
                width: double.infinity,
                child: TransactionCard(
                  Provider.of<TransactionProvider>(context).itemMap,
                  deviceWidth,
                  _scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showFab
          ? null
          : FadeTransition(
              opacity: _hideAnimation,
              child: Fab(deviceHeight, deviceWidth, _scrollController),
            ),
    );
  }
}
