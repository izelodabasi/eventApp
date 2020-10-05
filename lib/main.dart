import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:event/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page/rootpage.dart';
import 'model/user.dart';
import 'service/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authService = AuthService();
    return StreamProvider<User>.value(
      value: authService.user,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xff70a1ff),
            accentColor: Color(0xff70a1ff),
            buttonColor: Color(0xff5352ed),
            textSelectionColor: Colors.black,
            textSelectionHandleColor: Colors.grey,
            focusColor: Colors.blueGrey[50],
            primaryColorDark: Colors.black,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, displayColor: Colors.black),
            appBarTheme: AppBarTheme(
              elevation: 5,
              color: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.black, displayColor: Colors.black),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.black,
              textTheme: ButtonTextTheme.normal,
            ),
            timePickerTheme: TimePickerThemeData(
              dialTextColor: Colors.black,
            )),
        darkTheme: ThemeData(
          timePickerTheme: TimePickerThemeData(
              dialTextColor: Colors.black,
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              entryModeIconColor: Colors.black),
          brightness: Brightness.dark,
          primaryColor: Color(0xff70a1ff),
          accentColor: Color(0xff70a1ff),
          buttonColor: Color(0xff5352ed),
          textSelectionColor: Colors.white,
          textSelectionHandleColor: Colors.grey,
          focusColor: Colors.grey[800],
          cardColor: Colors.white,
          primaryColorDark: Colors.white,
          scaffoldBackgroundColor: Colors.grey[900],
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white),
          appBarTheme: AppBarTheme(
            elevation: 5,
            color: Colors.grey[900],
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, displayColor: Colors.white),
          ),
          buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
            ),
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.normal,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RootPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (Container(
              height: 100,
              child: Image.asset('assets/images/sincap_cagin.png'))),
          Text(
            'GATHERER',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          FutureBuilder<List>(
            future: updateEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container();
              }
              if (snapshot.hasError) {
                // return: show error widget
              }
              List events = snapshot.data ?? [];
              for (int i = 0; i < events.length; i++) {
                int month = int.parse(events[i].date.split('-')[1]);
                int day = int.parse(events[i].date.split('-')[2]);
                if (month < DateTime.now().month) {
                  Firestore.instance
                      .collection('events')
                      .document(events[i].eventid)
                      .updateData(
                    {
                      'isCompleted': true,
                    },
                  );
                } else if (month == DateTime.now().month &&
                    day < DateTime.now().day) {
                  Firestore.instance
                      .collection('events')
                      .document(events[i].eventid)
                      .updateData(
                    {
                      'isCompleted': true,
                    },
                  );
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future<List> updateEvents() async {
    List list = await Firestore.instance
        .collection("events")
        .where('isCompleted', isEqualTo: false)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());
    return list;
  }
}
