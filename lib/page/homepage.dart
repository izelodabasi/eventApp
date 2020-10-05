import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:event/model/user.dart';
import 'package:event/page/newevent.dart';
import 'package:event/page/pasteventpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
//import 'package:table_calendar/table_calendar.dart';
import 'package:event/service/database.dart';
import 'profilepage.dart';
import 'usereventpage.dart';
import 'eventpage.dart';
import 'package:date_format/date_format.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setUpNotifications(String uid) {
    _setUpNotifications(uid);
    setState(() {
      setupNotifications = true;
    });
  }

  final List<dynamic> _children = [
    MainEventPage(),
    UserEventPage(),
    PastEventPage(),
    ProfilePage(),
  ];
  bool setupNotifications = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (setupNotifications == false && user != null) {
      setUpNotifications(user.uid);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).focusColor,
        selectedItemColor: Theme.of(context).buttonColor,
        unselectedItemColor: Theme.of(context).textSelectionHandleColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.event_note),
            title: new Text('All Events'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.event),
            title: new Text('My Events'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text('Past Events'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          )
        ],
      ),
    );
  }
}

Future<Null> _setUpNotifications(String uid) async {
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );

  _firebaseMessaging.getToken().then((token) {
    print("Firebase Messaging Token: " + token);
    Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({"androidNotificationToken": token});
  });
}

class MainEventPage extends StatefulWidget {
  @override
  _MainEventPageState createState() => _MainEventPageState();
}

class _MainEventPageState extends State<MainEventPage> {
  //CalendarController _controller;
  String _selectedDate;
  DatePickerController _controller = DatePickerController();
  List<DateTime> dates = [];

  @override
  void initState() {
    super.initState();

    //_controller = CalendarController();
    _selectedDate = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        [yyyy, '-', mm, '-', dd]);
  }

  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    dates.length == 0 ? getDateList() : null;

    if (userData == null) {
      return Container();
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Events'),
            bottom: TabBar(
              indicatorColor: Theme.of(context).buttonColor,
              indicatorWeight: 3,
              labelColor: Theme.of(context).textSelectionColor,
              unselectedLabelColor: Theme.of(context).textSelectionHandleColor,
              tabs: <Widget>[
                Tab(
                  text: 'All Events',
                ),
                Tab(
                  text: 'Selected Events',
                ),
                Tab(
                  text: 'Maps',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewEvent(),
                ),
              );
            },
          ),
          body: TabBarView(
            children: [
              Container(
                child: new Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    /* TableCalendar(
                        initialCalendarFormat: CalendarFormat.week,
                        headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonShowsNext: false,
                        ),
                        calendarStyle: CalendarStyle(
                          todayColor: Theme.of(context).primaryColor,
                          selectedColor: Theme.of(context).buttonColor,
                        ),
                        onDaySelected: (date, events) {
                          setState(() {
                            _selectedDate = formatDate(
                                DateTime(date.year, date.month, date.day),
                                [yyyy, '-', mm, '-', dd]);
                            print(_selectedDate);
                          });
                        },
                        calendarController: _controller,
                      ), */
                    DatePicker(DateTime.now(),
                        width: 60,
                        height: 80,
                        activeDates: dates,
                        controller: _controller,
                        monthTextStyle: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        dayTextStyle: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        dateTextStyle: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Theme.of(context).buttonColor,
                        deactivatedColor:
                            Theme.of(context).textSelectionHandleColor,
                        selectedTextColor: Theme.of(context).focusColor,
                        onDateChange: (date) {
                      setState(() {
                        _selectedDate = formatDate(
                            DateTime(date.year, date.month, date.day),
                            [yyyy, '-', mm, '-', dd]);
                      });
                    }),
                    SizedBox(height: 5),
                    EventsList(date: _selectedDate)
                  ],
                ),
              ),
              Container(
                child: new SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      SelectedEventsList(),
                    ],
                  ),
                ),
              ),
              MapPage(uid: userData.uid),
            ],
          ),
        ),
      );
    }
  }

  getDateList() async {
    List dateList = await DatabaseService().getDates();
    List distinctList = dateList.toSet().toList();
    List<DateTime> datetimeList = [];

    for (int i = 0; i < distinctList.length; i++) {
      int month = int.parse(distinctList[i].split('-')[1]);
      int day = int.parse(distinctList[i].split('-')[2]);
      int year = int.parse(distinctList[i].split('-')[0]);
      var date = new DateTime.utc(year, month, day);
      datetimeList.add(date);
    }
    setState(() {
      dates = datetimeList;
    });
  }
}

class EventsList extends StatefulWidget {
  final String date;
  EventsList({Key key, @required this.date}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List joinState = [];
  List owners = new List();
  String preDate = '';

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final userData = Provider.of<UserData>(context);

    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }

    return FutureBuilder<List>(
      future: db.getDateEvents(widget.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // return: show error widget
        }
        List eventsOfUser = userData.eventsOfUser;
        List events = snapshot.data ?? [];
        events.sort((a, b) => a.time.compareTo(b.time));

        preDate != widget.date
            ? {
                getOwnerList(events),
                preDate = widget.date,
              }
            : null;

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < events.length; i++)
                  (eventsOfUser.contains(events[i].eventid))
                      ? Container(
                          height: 1,
                          child: Text(''),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventPage(
                                  event: events[i],
                                  owner: owners[i],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            margin: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15, top: 15),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: new Column(
                              children: <Widget>[
                                Container(
                                  height: height,
                                  alignment: Alignment(0.9, 0.7),
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: new DecorationImage(
                                      image: NetworkImage(events[i].photoUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      owners.length == events.length
                                          ? Positioned(
                                              bottom: 35,
                                              left: 10,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            owners[i].photoUrl),
                                                    radius: 12.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    owners[i].username,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Text("Loading"),
                                      Positioned(
                                        bottom: 5,
                                        left: 10,
                                        child: Text(
                                          events[i].name,
                                          style: TextStyle(
                                            color: Theme.of(context).cardColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          height: 40,
                                          width: 100,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white30,
                                          ),
                                          child: (userData.selectedEvents
                                                      .contains(
                                                          events[i].eventid) ==
                                                  true)
                                              ? Center(
                                                  child: Text(
                                                    "GOING",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    'NOT GOING',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Divider(),
                              ],
                            ),
                          ),
                        ),
              ],
            ),
          ),
        );
      },
    );
  }

  getOwnerList(List events) async {
    List users = new List();
    for (int i = 0; i < events.length; i++) {
      users.add(await DatabaseService().getUserData(events[i].createdBy));
    }
    setState(() {
      owners = users;
    });
  }
}

class SelectedEventsList extends StatefulWidget {
  @override
  _SelectedEventsListState createState() => _SelectedEventsListState();
}

class _SelectedEventsListState extends State<SelectedEventsList> {
  List joinState = [];
  List owners = new List();

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final userData = Provider.of<UserData>(context);
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    return FutureBuilder<List>(
      future: db.getEventList(userData.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // return: show loading widget
        }
        if (snapshot.hasError) {
          // return: show error widget
        }
        List events = snapshot.data ?? [];
        owners.length == 0 ? getOwnerList(events) : null;
        print(owners);

        return Column(
          children: <Widget>[
            for (int i = 0; i < events.length; i++)
              (userData.selectedEvents.contains(events[i].eventid) == true)
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventPage(
                              event: events[i],
                              owner: owners[i],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, bottom: 15, top: 15),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: new Column(
                          children: <Widget>[
                            Container(
                              height: height,
                              alignment: Alignment(0.9, 0.7),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: new DecorationImage(
                                  image: NetworkImage(events[i].photoUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  owners.length == events.length
                                      ? Positioned(
                                          bottom: 35,
                                          left: 10,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    owners[i].photoUrl),
                                                radius: 12.0,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                owners[i].username,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Text("Loading"),
                                  Positioned(
                                    bottom: 5,
                                    left: 10,
                                    child: Text(
                                      events[i].name,
                                      style: TextStyle(
                                        color: Theme.of(context).cardColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      height: 40,
                                      width: 100,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white30,
                                      ),
                                      child: (userData.selectedEvents.contains(
                                                  events[i].eventid) ==
                                              true)
                                          ? Center(
                                              child: Text(
                                                "GOING",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'NOT GOING',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Divider(),
                          ],
                        ),
                      ),
                    )
                  : Container(),
          ],
        );
      },
    );
  }

  getOwnerList(List events) async {
    List users = new List();
    for (int i = 0; i < events.length; i++) {
      print(events[i].createdBy);
      users.add(await DatabaseService().getUserData(events[i].createdBy));
    }

    setState(() {
      owners = users;
    });
  }
}

class MapPage extends StatefulWidget {
  final String uid;
  MapPage({Key key, @required this.uid}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  LatLng _initialPosition = LatLng(45.48, 9.216);
  Location location = Location();
  List<Marker> locationMarkers = [];
  List locationlist = [];

  @override
  Widget build(BuildContext context) {
    //final userData = Provider.of<UserData>(context);
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height - 190,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: _initialPosition, zoom: 12),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          markers: Set.from(locationMarkers),
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (int i = 0; i < locationlist.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      print(locationMarkers);
                      _gotoLocation(locationMarkers[i].position.latitude,
                          locationMarkers[i].position.longitude);
                    },
                    child: Card(
                      color: Theme.of(context).focusColor,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: new Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width - 200,
                              height: height - 100,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(locationlist[i].photoUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            ListTile(
                                title: Text(locationlist[i].name),
                                subtitle: Text(locationlist[i].date)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ]);
  }

  _onMapCreated(GoogleMapController controller) async {
    getList();
    setState(() {
      mapController = controller;
    });
  }

  getList() async {
    var list = await DatabaseService().getEventList(widget.uid);

    setState(() {
      locationlist = list;
    });
    for (int i = 0; i < list.length; i++) {
      print(list[i].location);
      Geolocator().placemarkFromAddress(list[i].location).then((result) {
        var point =
            LatLng(result[0].position.latitude, result[0].position.longitude);
        print(point);
        setState(
          () {
            locationMarkers.add(Marker(
              markerId: MarkerId(list[i].name),
              position: point,
              infoWindow: InfoWindow(title: list[i].name),
              onTap: () {
                _gotoLocation(
                    result[0].position.latitude, result[0].position.longitude);
              },
            ));
          },
        );
      });
    }
  }

  _gotoLocation(double lat, double long) async {
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 14)));
  }
}
